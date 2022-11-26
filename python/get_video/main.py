from pytube import YouTube


def Download(link):
    youtubeObject = YouTube(link)
    youtubeObject = youtubeObject.streams.get_highest_resolution()
    try:
        youtubeObject.download()
    except:
        print("An error has occurred")
    print("Download is completed successfully")


def main():
    link = input("Enter the YouTube video URL: ")
    Download(link)


if __name__ == '__main__':
    main()
