from ast import Constant
import getopt
import json
import os
import requests
import sys


def usage():
    print(
        'Usage: python todo.py [-d] [-h] -f FILENAME [-t TITLE] [-l LIST-ID] [-i ITEM-ID]')
    print(' -d (--debug)            displays additional information')
    print(' -h (--help)             displays this usage information and quits')
    print(' -f (--file) FILENAME    opens the (JSON) file containing a query or mutation')
    print(' -t (--title) TITLE      the title of a new list or item')
    print(' -l (--list-id) LIST-ID  the ID of a todo list')
    print(' -i (--item-id) ITEM-ID  the ID of a todo list item')

    sys.exit(0)


def debug_print(d, s):
    if d:
        print(s)


def main():
    '''Execute GraphQL query/mutation from JSON file'''

    # Parse command-line args
    # Remove first argument from the list of command line arguments
    argumentList = sys.argv[1:]

    # Options
    options = "df:hi:l:t:"

    # Long options
    long_options = ['debug', 'file', 'help', 'item-id', 'list-id', 'title']

    show_help = False
    debug = False
    filename = ''
    ITEM_ID = 'ITEM-ID'
    LIST_ID = 'LIST-ID'
    TITLE = 'TITLE'

    item_id = ''
    list_id = ''
    title = ''

    try:
        # Parsing argument
        arguments, values = getopt.getopt(argumentList, options, long_options)

        # checking each argument
        for currentArgument, currentValue in arguments:

            if currentArgument in ("-d", "--debug"):
                debug = True
                debug_print(debug, 'Debug printing is enabled')
                debug_print(debug, '')

            elif currentArgument in ("-f", "--file"):
                filename = currentValue
                debug_print(debug, 'Opening ' + filename)
                debug_print(debug, '')

            elif currentArgument in ("-h", "--help"):
                usage()

            elif currentArgument in ('-i', '--item-id'):
                item_id = currentValue

            elif currentArgument in ('-l', '--list-id'):
                list_id = currentValue

            elif currentArgument in ('-t', '--title'):
                title = currentValue

    except getopt.error as err:
        # output error, and quit
        print(str(err))
        sys.exit(1)

    invalid = False

    # Get environment variables
    api_key = os.getenv('API_KEY')  # OR: api_key = os.environ.get('API_KEY')
    if api_key == '':
        print('You must set the API_KEY environment variable')
        invalid = True
    else:
        debug_print(debug, 'API key: ' + api_key)
        debug_print(debug, '')

    end_point = os.getenv('ENDPOINT')
    if end_point == '':
        print('You must set the ENDPOINT environment variable')
        invalid = True
    else:
        debug_print(debug, 'Endpoint: ' + end_point)
        debug_print(debug, '')

    if filename == '':
        print('You must supply a (JSON) file to open')
        usage()

    # Quit if we haven't got the info required
    if invalid:
        sys.exit(1)

    # Get file as one string, without end-of-line chars
    try:
        content = open(filename, 'r').read().replace('\n', ' ')
    except FileNotFoundError:
        # output error, and quit
        print('Could not find ' + filename)
        sys.exit(1)

    debug_print(debug, 'Contents of ' + filename + ':')
    debug_print(debug, content)
    debug_print(debug, '')

    # If content contains ITEM-ID, replace it with item_id
    found = content.find(ITEM_ID)

    if found != -1:
        # Make sure that item_id is set
        if item_id == '':
            print(filename + ' contains a ' + ITEM_ID +
                  ' placeholder, but you have not specified a -i ITEM-ID command-line arg')
            sys.exit(1)

        content = content.replace(ITEM_ID, item_id)

    # If content contains LIST-ID, replace it with list_id
    found = content.find(LIST_ID)

    if found != -1:
        # Make sure that list_id is set
        if list_id == '':
            print(filename + ' contains a ' + LIST_ID +
                  ' placeholder, but you have not specified a -l LIST-ID command-line arg')
            sys.exit(1)

        content = content.replace(ITEM_ID, item_id)

    # If content contains TITLE, replace it with title
    found = content.find(TITLE)

    if found != -1:
        # Make sure that item_id is set
        if title == '':
            print(filename + ' contains a ' + TITLE +
                  ' placeholder, but you have not specified a -t TITLE command-line arg')
            sys.exit(1)

        content = content.replace(TITLE, title)

    debug_print(debug, 'Updated contents:')
    debug_print(debug, content)
    debug_print(debug, '')

    headers = {"Content-Type": "application/json", "x-api-key": api_key}
    response = requests.post(
        end_point, data=content, headers=headers)

    status = response.status_code

    if status >= 200 and status < 300:
        if debug:
            print('JSON response:')
            print(response.json())
        else:
            json_formatted_str = json.dumps(response.json(), indent=2)
            print(json_formatted_str)
    else:
        print('Got a bad status code: ' + str(status))


if __name__ == '__main__':
    main()
