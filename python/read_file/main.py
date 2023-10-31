def read_file(filename):
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
    print("{:s}% has {:n} characters".format(filename, count + num_lines-1))


def main():
    try:
        fname = input("Enter a filename to read CTRL-C [ENTER] to quit: ")
        read_file(fname)

    except KeyboardInterrupt:
        print("Exiting")


if __name__ == '__main__':
    main()
