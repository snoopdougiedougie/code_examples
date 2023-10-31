def echo(info):
    print("You entered:")
    print(info)


def main():
    try:
        while True:
            info = input("Please enter some text or CTRL-C [ENTER] to quit: ")
            echo(info)

    except KeyboardInterrupt:
        print("Exiting")


if __name__ == '__main__':
    main()
