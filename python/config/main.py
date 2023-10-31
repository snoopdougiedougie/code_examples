import sys
import getopt
import json


def help():
    print()
    print('python main.py [-c CONFIG-FILE] [-d] [-i INPUT-FILE] [-h]')
    print("    where CONFIG-FILE contains configuration information, such as the input file we read")
    print("    if omitted defaults to config.json")
    print("    -d (debug) emits additional information")
    print("    INPUT-FILE is the input file, overriding any value is CONFIG-FILE")
    print("    if omitted and missing from CONFIG-FILE, defaults to input.txt")
    print("    -h (help) shows this message and quits")
    print()


def debug_print(d, s):
    if d:
        print(s)


def process_file(debug, filename):
    debug_print(debug, "Processing {:s}".format(filename))

    file1 = open(filename, 'r')
    count = 0
    num_lines = 0

    while True:
        num_lines += 1
        # Get next line from file
        line = file1.readline()

        # if line is empty
        # end of file is reached
        if not line:
            break

        # get # chars in line, without EOL char
        count += len(line)
    file1.close()

    # wc -c includes EOL char, save for final line
    print("{:s} has {:n} characters".format(filename, count + num_lines-1))


def main(argv):
    configfile = 'config.json'
    debug = False
    inputfile = 'input.txt'

    opts, args = getopt.getopt(argv, "cdi:o:", ["ifile=", "ofile="])

    # Get configuration values from configfile
    # Read from JSON file
    # read file
    with open(configfile, 'r') as cfile:
        data = cfile.read()

        # parse file
        obj = json.loads(data)

        if str(obj['debug']) == "True":
            debug = True

        if str(obj['infile']) != "":
            inputfile = str(obj['infile'])

    # Override any default or config values
    for opt, arg in opts:
        if opt == '-d':
            debug = True
        if opt == '-h':
            help()
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg

    if inputfile == "":
        print("You must specify an input filename")
        print("on the command line (-i INPUT-FILE) or in config.json (\"infile\": \"FILENAME\")")
        print("or show help (-h on the command line)")
        help()
        sys.exit()

    debug_print(debug, "")
    debug_print(debug, "Debugging enabled")
    debug_print(debug, "Config file: {:s}".format(inputfile))
    debug_print(debug, "")

    process_file(debug, inputfile)


if __name__ == "__main__":
    main(sys.argv[1:])
