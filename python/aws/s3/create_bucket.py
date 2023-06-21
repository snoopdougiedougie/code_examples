import getopt
import logging
import sys

import boto3
from botocore.exceptions import ClientError


def usage():
    print(
        'Usage: python create_bucket.py [-d] [-h] -b BUCKET-NAME [-r REGION]')
    print(' -d (--debug)   displays additional information')
    print(' -h (--help)    displays this usage information and quits')
    print(' -b (--bucket)  BUCKET-NAME, where BUCKET-NAME is the name of the new bucket')
    print(' -r (--region)  REGION, where REGION is the name of the region. By default it is us-west-2')

    sys.exit(0)


def debug_print(d, s):
    if d:
        print(s)


def create_bucket(bucket_name, region):
    """Create an S3 bucket in a specified region

    If a region is not specified, the bucket is created in us-west-2

    :param bucket_name: Bucket to create
    :param region: String region to create bucket in, e.g., 'us-west-2'
    :return: True if bucket created, else False
    """

    # Create bucket
    try:
        s3_client = boto3.client('s3', region_name=region)
        location = {'LocationConstraint': region}
        s3_client.create_bucket(Bucket=bucket_name,
                                CreateBucketConfiguration=location)
    except ClientError as e:
        logging.error(e)
        return False
    return True


def main():
    # Parse command-line args
    # Remove first argument from the list of command line arguments
    argumentList = sys.argv[1:]

    # Options
    options = "b:dhr:"

    # Long options
    long_options = ['bucket', 'debug', 'help', 'region']

    show_help = False
    debug = False
    region = "us-west-2"

    try:
        # Parsing argument
        arguments, values = getopt.getopt(argumentList, options, long_options)

        # checking each argument
        for currentArgument, currentValue in arguments:
            if currentArgument in ("-d", "--debug"):
                debug = True
                debug_print(debug, 'Debug printing is enabled')
                debug_print(debug, '')

            elif currentArgument in ("-h", "--help"):
                usage()

            elif currentArgument in ("-b", "--bucket"):
                bucket = currentValue
                debug_print(debug, 'Creating bucket ' + bucket)

            elif currentArgument in ("-r", "--region"):
                region = currentValue
                debug_print(debug, 'Setting region to ' + region)

    except getopt.error as err:
        # output error, and quit
        print(str(err))
        sys.exit(1)

    made_it = create_bucket(bucket, region)

    if made_it:
        print('Created bucket ' + bucket + ' in region ' + region)


if __name__ == '__main__':
    main()
