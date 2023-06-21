#!/bin/bash

set -eo pipefail

VERSION="0.1.0"
if [[ -z "${DOCTAVE_HOST}" ]]; then
    _DOCTAVE_HOST="https://dashboard.doctave.com"
else
    _DOCTAVE_HOST="$DOCTAVE_HOST"
fi

HELP_TEXT="Doctave Push $VERSION

Upload your documentation to Doctave.com. Add this script to your CI to have
always up-to-date docs. This tool can be configured via environment variables,
or via command line flags.

USAGE:
    doctave-upload [OPTIONS] PATH

ARGS:
    <PATH>:
            The directory containing the doctave.yaml file.

OPTIONS:
    -t --upload-token:
            Upload token linked to the Doctave project.

            Not required if DOCTAVE_UPLOAD_TOKEN environment variable is set"

ZIPPED="/tmp/doctave-upload-$RANDOM.zip"
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -t|--upload-token)
    UPLOAD_TOKEN="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--help)
    HELP="Y"
    shift # past argument
    ;;
    *)    # unknown option
    DOCS_PATH+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ "$HELP" == "Y" ]; then
    echo "$HELP_TEXT"
    exit 0
fi

UPLOAD_TOKEN="${UPLOAD_TOKEN:-$DOCTAVE_UPLOAD_TOKEN}"

input_error() {
    echo "Error: $1."
    echo "Run \`doctave-upload --help\` for usage instructions"
    exit 1
}

dependency_error() {
    echo "Could not find runtime dependency: $1"
    exit 1
}

error() {
    echo -e "Error publishing docs:\n$1"
    exit 1
}

detect_dependencies() {
    if ! command -v git &> /dev/null; then
        dependency_error "git"
    fi

    if ! command -v zip &> /dev/null; then
        dependency_error "zip"
    fi
}

validate_dir() {
    if [[ ${#DOCS_PATH[@]} == 0 ]]; then
        input_error "Missing path to docs directory"
    fi
    if [[ ${#DOCS_PATH[@]} != 1 ]]; then
        input_error "More than one docs directory path passed"
    fi

    DOCS_PATH="${DOCS_PATH[0]}"

    if ! [ -f "$DOCS_PATH/doctave.yaml" ]; then
        input_error "Could not find doctave.yaml in the provided path"
    fi
}

detect_git_info() {
    if ! (git status > /dev/null 2>&1); then
        error "No Git repository found. Every Doctave build requires an associated Git commit.\nRun the following command to create one and try again:\n\n\tgit init && git add . && git commit -m \"Initial commit\"\n"
    fi

    if ! (git log > /dev/null 2>&1); then
        error "No Git commit found. Every Doctave build requires an associated Git commit.\nRun the following command to create one and try again:\n\n\tgit add . && git commit -m \"Initial commit\"\n"
    fi

    _GITHUB_BRANCH_NAME=${GITHUB_HEAD_REF:-${GITHUB_REF_NAME}}
    _LOCAL_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

    GIT_BRANCH="${_GITHUB_BRANCH_NAME:-${_LOCAL_BRANCH_NAME}}"
    GIT_AUTHOR="$(git show -s --format='%ae' HEAD)"
    GIT_SHA="$(git rev-parse HEAD)"
}

validate_dir
detect_dependencies
detect_git_info

pushd "$DOCS_PATH" > /dev/null

zip -q "**/.*" -r $ZIPPED -x ./*

popd > /dev/null

resp="$(curl --silent --show-error -w "|%{http_code}" -H "Authorization: Bearer $UPLOAD_TOKEN" -F "git_sha=$GIT_SHA" -F "git_branch=$GIT_BRANCH" -F "git_author_email=$GIT_AUTHOR" -F docs="@$ZIPPED" "$_DOCTAVE_HOST"/projects/upload)"

body="$( echo "$resp" | cut -d '|' -f 1 )"
http_code="$( echo "$resp" | cut -d '|' -f 2 )"


if [[ $http_code == "201" ]]; then
    echo "Done! Docs uploaded."
    exit 0
else
    echo "Error! Failed with code ${http_code}."
    echo "$body"
    exit 1
fi
