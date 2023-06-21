from ast import Constant
import getopt
import json
import os
import requests
import sys
import numpy as np


def usage():
    print(
        'Usage: python times.py [-d] [-h] [-f FILENAME]')
    print(' -d (--debug)            displays additional information')
    print(' -h (--help)             displays this usage information and quits')
    print(' -f (--file) FILENAME    opens FILENAME with a list of time pairs')
    print('                         If not supplied, defaults to times.txt')

    sys.exit(0)


def debug_print(d, s):
    if d:
        print(s)


def diff_times(line, debug):
    print(line)
    # line should have the format:
    # h:m:s h:m:s
    # where h is hours, m is minutes, s is seconds; one space separating the two times

    # split line into two times
    parts = line.split(" ", 1)
    #debug_print(debug, "Got two times:")
    #debug_print(debug, parts[0])
    #debug_print(debug, parts[1])

    # Now split each into three values, hours, minutes, seconds
    times1 = parts[0].split(":", 2)
    hours1 = times1[0]
    minutes1 = times1[1]
    seconds1 = times1[2]

    times2 = parts[1].split(":", 2)
    hours2 = times2[0]
    minutes2 = times2[1]
    seconds2 = times2[2]

    #debug_print(debug, hours1)
    #debug_print(debug, minutes1)
    #debug_print(debug, seconds1)
    #debug_print(debug, hours2)
    #debug_print(debug, minutes2)
    #debug_print(debug, seconds2)

    # Convert all times to seconds
    h1 = int(hours1)
    m1 = int(minutes1)
    s1 = int(seconds1)
    h2 = int(hours2)
    m2 = int(minutes2)
    s2 = int(seconds2)

    duration1 = s1 + 60*m1 + 3600*h1
    duration2 = s2 + 60*m2 + 3600*h2
    diff_seconds = duration2 - duration1

    debug_print(debug, "First time: %d" % duration1)
    debug_print(debug, "Second time: %d" % duration2)
    debug_print(debug, "Seconds diff: %d" % diff_seconds)

    diff_pct = int(100 * (diff_seconds / duration1))

    # Difference in seconds
    diff = duration2 - duration1
    diff_minutes = int(diff / 60)
    diff_seconds = int(diff % 60)

    print("The difference is %d minute(s) and %d second(s); about %d percent" %
          (diff_minutes, diff_seconds, diff_pct))

    print('')

    return diff_pct


def linreg(data):
    x = np.arange(0, len(data))
    y = np.array(data)
    z = np.polyfit(x, y, 1)
    print("The time difference equation (y = ax + b):")
    print("{0}x + {1}".format(*z))


def main():
    '''Compare a list of pairs of times'''

    # Parse command-line args
    # Remove first argument from the list of command line arguments
    argumentList = sys.argv[1:]

    # Options
    options = "df:h"

    # Long options
    long_options = ['debug', 'file', 'help']

    show_help = False
    debug = False
    filename = 'times.txt'

    try:
        # Parsing argument
        arguments, values = getopt.getopt(argumentList, options, long_options)

        # checking each argument
        for currentArgument, currentValue in arguments:

            if currentArgument in ("-d", "--debug"):
                debug = True

            elif currentArgument in ("-f", "--file"):
                filename = currentValue

            elif currentArgument in ("-h", "--help"):
                usage()

    except getopt.error as err:
        # output error, and quit
        print(str(err))
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

    # Read file one line at a time
    file1 = open(filename, 'r')
    Lines = file1.readlines()

    pct_list = []

    # Strip the newline character before calling diff_times,
    # which returns a percentage we keep track of.
    for line in Lines:
        diff_pct = diff_times(line.strip(), debug)
        pct_list.append(diff_pct)

    # Do some analysis on list
    linreg(pct_list)


if __name__ == '__main__':
    main()
