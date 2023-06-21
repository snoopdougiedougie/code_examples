import imaplib
import email
import getopt
import pprint
import re
import html2text
import sys
import unicodedata


def usage():
    print(
        'Usage: python get_email.py [-d(ebug)] -e(mail) EMAIL-ADDRESS [-h)elp)] [-s(erver) SERVER] -t(optic) TOPIC')
    print(' -d (--debug)                   displays additional information')
    print(' -e (--email)    EMAIL-ADDRESS  Your email address')
    print(' -h (--help)                    displays this usage information and quits')
    print(' -p (--password) PASSWORD)      Your email password')
    print(' -s (--server)   SERVER         connect to SERVER')
    print('                                If not supplied, defaults to imap.gmail.com')
    print(' -t (--topic)    TOPIC          The subject of the email')

    sys.exit(0)


def debug_print(d, s):
    if d:
        print(s)


class EmailRetriever:
    def __init__(self, server, email, password, subject):
        self.server = server
        self.email = email
        self.password = password
        self.subject = subject
        self.imap = self._connect_to_server()

    def _connect_to_server(self):
        """
        Connect to the IMAP server using the given username and password.
        Returns the IMAP4 object representing the connection.
        """
        imap = imaplib.IMAP4_SSL(self.server)
        imap.login(self.email, self.password)
        return imap

    def get_emails(self, folder="INBOX"):
        """
        Retrieve a list of email messages from the given folder on the IMAP server.
        Returns a list of email message objects.
        """
        self.imap.select(folder)
        # status, messages = self.imap.search(None, "ALL")
        # status, messages = self.imap.search(None, '(FROM "Julia at CoRise")')
        status, messages = self.imap.search(
            None, '(Subject "' + self.subject + '")')
        messages = messages[0].split(b' ')
        emails = []

        for msg in messages:
            _, data = self.imap.fetch(msg, "(RFC822)")
            emails.append(email.message_from_bytes(data[0][1]))

        return emails

    def parse_email(self, email):
        """
        Parse the header and body of the given email message.
        Returns a dictionary containing the parsed data.
        """

        parsed_email = {}

        # Get Header Content
        parsed_email["subject"] = self.header_decode(email.get("Subject"))
        parsed_email["from"] = self.header_decode(email.get("From"))
        parsed_email["to"] = self.header_decode(email.get("To"))
        parsed_email["delivered-to"] = self.header_decode(
            email.get("Delivered-To"))
        parsed_email["date"] = self.header_decode(email.get("Date"))
        parsed_email["reply-to"] = self.header_decode(email.get("Reply-to"))

        # Get Body
        parsed_email["zbody"] = self.parse_email_body(email)

        return parsed_email

    def parse_email_body(self, email):
        """
        Parse the body of the given email message.
        Returns a dictionary containing the plaintext and HTML versions of the body.
        """
        body = {"text": "", "zhtml": ""}
        if email.is_multipart():
            for part in email.get_payload():
                if part.get_content_type() == "text/plain":
                    body["text"] = self.remove_special_chars(
                        part.get_payload())
                elif part.get_content_type() == "text/html":
                    body["zhtml"] = html2text.html2text(part.get_payload())
        else:
            body["text"] = email.get_payload()
        return body

    def header_decode(self, header):
        hd = ""
        try:
            for part, encoding in email.header.decode_header(header):
                if isinstance(part, bytes):
                    part = part.decode(encoding or "utf-8")
                hd += part
        except TypeError:
            return ""

        return hd

    def remove_special_chars(self, string):
        # Normalize the string to remove accents
        string = unicodedata.normalize('NFD', string).encode(
            'ascii', 'ignore').decode('utf-8')

        # Remove all non-alphanumeric characters
        string = re.sub(r'[^a-zA-Z0-9\s]', '', string)

        # Remove extra whitespace
        string = re.sub(r'\s+', ' ', string).strip()

        return string

    def pretty_print_emails(self, emails):
        """
        Pretty print the content of the given email messages to the console.
        """
        for email in emails:
            pprint.pprint(self.parse_email(email))

    def write_emails_to_file(self, emails):
        """
        Write the content of the given email messages to a file with the given name.
        """
        # save to file
        num = 0
        for email in emails:
            email = self.parse_email(email)

            f = open("mail_" + str(num) + ".txt", "w")
            for key, value in email.items():
                f.write(f"{key}: {value}\n")
            f.close()
            num += 1


def main():
    # Parse command-line args
    # [-d(ebug)] -e(mail) EMAIL-ADDRESS [-h)elp)] [-s(erver) SERVER] -t(optic) TOPIC
    # Remove first argument from the list of command line arguments
    argumentList = sys.argv[1:]

    # Options
    options = "de:hp:s:t:"

    # Long options
    long_options = ['debug', 'email', 'help', 'password', 'server', 'topic']

    debug = False
    email = ''
    password = ''
    server = 'imap.gmail.com'
    topic = ''

    try:
        # Parsing argument
        arguments, values = getopt.getopt(argumentList, options, long_options)

        # checking each argument
        for currentArgument, currentValue in arguments:
            if currentArgument in ("-d", "--debug"):
                debug = True
            elif currentArgument in ("-e", "--email"):
                email = currentValue
            elif currentArgument in ("-h", "--help"):
                usage()
            elif currentArgument in ("-p", "--password"):
                password = currentValue
            elif currentArgument in ("-s", "--server"):
                server = currentValue
            elif currentArgument in ("-t", "--topic"):
                topic = currentValue

    except getopt.error as err:
        # output error, and quit
        print(str(err))
        sys.exit(1)

    print('Calling EmailRetriever with the following args:')
    print('  server:        ' + server)
    print('  email address: ' + email)
    print('  password:      ' + password)
    print('  topic:         ' + topic)

    if debug:
        print('  debug:         on')
    else:
        print('  debug:         off')

    print('')
    #    sys.exit(0)

    email_retriever = EmailRetriever(
        server, email, password, topic)
    emails = email_retriever.get_emails()

    # If list isn't empty, show it
    print('Found ' + str(len(emails)) + ' email(s) with subject')

    email_retriever.pretty_print_emails(emails)
    email_retriever.write_emails_to_file(emails)


if __name__ == '__main__':
    main()
