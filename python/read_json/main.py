import sys
import getopt
import json


def help():
    print()
    print('python main.py [-i INPUT-FILE -o OUTPUT-FILE] [-h]')
    print("    where INPUT-FILE is the JSON file we read")
    print("    and OUTPUT-FILE is the TXT file we write")
    print("    -h (help) shows this message and quits")
    print()


def process_json(debug, infile, outfile):
    if debug:
        print('Input file:  ', infile)
        print('Output file: ', outfile)

    # Read from JSON file
    inf = open(infile, 'r')
    ouf = open(outfile, 'w')

    # returns JSON object as
    # a dictionary
    data = json.load(inf)

    # Iterating through the JSON file and barf out the contents to output file
    for i in data['details']:
        for key in i.keys():
            ouf.write("{:s}: {:s}\n".format(key, i[key]))

    # Close files
    inf.close()
    ouf.close()


def main(argv):
    inputfile = ''
    outputfile = ''
    debug = False
    opts, args = getopt.getopt(argv, "dhi:o:", ["ifile=", "ofile="])

    for opt, arg in opts:
        if opt == '-d':
            debug = True
        if opt == '-h':
            help()
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg

    if inputfile == "" or outputfile == "":
        print("You must specify both an input and output string or show help (below)")
        help()
        sys.exit()

    process_json(debug, inputfile, outputfile)


if __name__ == "__main__":
    main(sys.argv[1:])
