# Go(lang)

## Getting the latest version of go

Navigate to the [go installation page](https://go.dev/doc/install),
download the latest bits and install them.
(1.20.3 for Windows when this was written).

## Using multiple Go environments

You can download, install, and use different versions of Go,
where VERSION is a Go version, such as *1.17*:

```console
go install golang.org/dl/goVERSION@latest
goVERSION download
alias go="goVERSION"

Make sure you did it correctly:

```console
go version
```

Which should show something like:

```console
go version go1.17 windows/amd64
```

## Creating a new go project

The following command creates a new project *PROJECT-NAME*,
in the folder *PROJECT-NAME* within the current folder.

```console
mkdir PROJECT-NAME
cd PROJECT-NAME
```

## Adding source code

Create the standard Go source file, **main.go**:

```console
vi main.go
```

Add the following to **main.go**:

```golang
package main

import "fmt"

func main() {
    fmt.Println("Hello, world.")
}
```

Initialize the project (creates *go.mod*)
and :

```console
go mod init main
```

Run the following commands from the root of *PROJECT-NAME* to:
- clean up the source files
- vet the source files
- lint the project
- build the project

```console
go mod tidy
go vet *.go
golangci-lint run
go build
```

Fix any problems, rinse and repeat.

Run either of the following commands to run the app:

```console
./main.exe
go run main.go
```

Either should display:

```console
Hello, world.
```

