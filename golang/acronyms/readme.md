# Terms and Acronyms

This file describes the go(lang) project in this folder.
It is designed to manage a repository/database of acronyms or terms, and their definitions.
Currently it uses DynamoDB local as the backing store,
but I see no reason why it couldn't be easily retargeted to another,
such as MySQL or MongoDB.
I'll save that work for V2.0.

## Installing and Configuring DynamoDB Local

See [DynamoDBLocal]
(https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html).

## Using the AWS CLI with DynamoDB Local
To get a list of the DynamoDB local tables using the AWS CLI:

`aws dynamodb list-tables --endpoint-url http://localhost:8000`

See [https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodb/index.html]
(dynamodb) for a list of DynamoDB commands
and [https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html]
(Installing or updating the latest version of the AWS CLI) to install the AWS CLI.

## About the Code

You can always get help by using the -h **help** option.

### Configuration file

The **config.json** file contains three entries:

- *Table*, which specifies the default table name.
  You can override this value using the *-t* **TABLE** command-line argument.
- *Output*, which specifies the default output format.
  You can override this value using the *-o* **FORMAT** command-line argument.
- *File*, which specifies the default file base name for output.
  You can override this value using the *-f* **FILENAME** command-line argument.

### Arguments
Argument value with spaces should NOT be enclosed in double quotes.

```shell
-h (help) displays this text and quits
-d (debug) displays some debugging information
-o FORMAT (output format), either **csv** for comma-separated values, **html** for HTML, or **text** for text output.
   Overrides the *Output* value in the configuration file. Requires a -t TABLE argument.
-t TABLE (the name of the TABLE to use in DynamoDB Local).
   Overrides the *Table* value in the configuration file.
-f FILENAME specifies the basename of the output file (with .csv, .html, or .txt appended based on FORMAT)
   Overrides the *File* value in the configuration file.
```
