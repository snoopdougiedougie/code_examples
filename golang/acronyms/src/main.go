package main

import (
	"bufio"
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"sort"
	"strings"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

type Config struct {
	Table  string `json:"Table"`
	Output string `json:"Output"`
	File   string `json:"File"`
}

var configFileName = "config.json"

var globalConfig Config

// Entry defines the glossary entries for the table
type Entry struct {
	Key   string
	Value string
}

func DebugPrint(debug bool, s string) {
	if debug {
		fmt.Println(s)
	}
}

func populateConfiguration(d bool) error {
	content, err := ioutil.ReadFile(configFileName)
	if err != nil {
		return err
	}

	text := string(content)

	err = json.Unmarshal([]byte(text), &globalConfig)
	if err != nil {
		return err
	}

	return nil
}

func CreateLocalClient() *dynamodb.Client {
	cfg, err := config.LoadDefaultConfig(context.TODO(),
		config.WithRegion("us-east-1"),
		config.WithEndpointResolverWithOptions(aws.EndpointResolverWithOptionsFunc(
			func(service, region string, options ...interface{}) (aws.Endpoint, error) {
				return aws.Endpoint{URL: "http://localhost:8000"}, nil
			})),
		config.WithCredentialsProvider(credentials.StaticCredentialsProvider{
			Value: aws.Credentials{
				AccessKeyID: "dummy", SecretAccessKey: "dummy", SessionToken: "dummy",
				Source: "Hard-coded credentials; values are irrelevant for local DynamoDB",
			},
		}),
	)
	if err != nil {
		panic(err)
	}

	return dynamodb.NewFromConfig(cfg)
}

func TableExists(svc *dynamodb.Client, table string) bool {
	return false
}

func createTable(svc *dynamodb.Client, table *string) {
	if *table == "" {
		fmt.Println("You must specify a table name (Table in config.json or -t TABLE)")
		os.Exit(1)
	}

	exists := TableExists(svc, *table)

	if exists {
		fmt.Println("The table already exists")
		return
	}

	AttributeDefinitions :=
		[]types.AttributeDefinition{
			{
				AttributeName: aws.String("Key"),
				AttributeType: types.ScalarAttributeTypeS,
			},
			{
				AttributeName: aws.String("Value"),
				AttributeType: types.ScalarAttributeTypeS,
			},
		}

	KeySchema := []types.KeySchemaElement{
		{
			AttributeName: aws.String("Key"),
			KeyType:       types.KeyTypeHash,
		},
		{
			AttributeName: aws.String("Value"),
			KeyType:       types.KeyTypeRange,
		},
	}

	_, err := svc.CreateTable(context.TODO(), &dynamodb.CreateTableInput{
		AttributeDefinitions: AttributeDefinitions,
		KeySchema:            KeySchema,
		BillingMode:          types.BillingModePayPerRequest,
		TableName:            table,
	})
	if err != nil {
		fmt.Println("Could not create table")
		fmt.Println(err)
		os.Exit(1)
	}
}

func listTables(svc *dynamodb.Client, table *string) {
	tables, err := svc.ListTables(context.TODO(), &dynamodb.ListTablesInput{})
	if err != nil {
		fmt.Println("Could not list the tables:")
		fmt.Println(err)
		os.Exit(1)
	}

	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println("Tables:")
	fmt.Println("")

	for _, n := range tables.TableNames {
		fmt.Println(n)
	}

	fmt.Println("")
}

func getKeyName(debugPtr *bool, svc *dynamodb.Client) string {
	// Get key and value from user
	fmt.Println("Enter the key name:")

	reader := bufio.NewReader(os.Stdin)

	key, _ := reader.ReadString('\n')
	// convert CRLF to LF
	key = strings.Replace(key, "\n", "", -1)

	DebugPrint(*debugPtr, "Key: "+key)

	return key
}

func addKeyValuePair(debugPtr *bool, svc *dynamodb.Client, table *string, key string) {
	if *table == "" {
		fmt.Println("You must specify a table name (Table in config.json or -t TABLE)")
		os.Exit(1)
	}

	fmt.Println("Enter the value (no need to put it in double-quotes if it has spaces).")
	fmt.Println("You can enter multiple lines. A blank line signifies the end of the value.")
	reader := bufio.NewReader(os.Stdin)

	// Create with a dummy value so we can detect the end.
	value := ""

	for true {
		v, _ := reader.ReadString('\n')

		// Replace line break with space.
		v = strings.Replace(v, "\n", " ", -1)

		if v == " " {
			break
		} else {
			// Replace multiple white spaces with one space.
			for true {
				l := len(v)
				v = strings.Replace(v, "  ", " ", -1)

				if l == len(v) {
					break
				}
			}

			value += v
		}
	}

	DebugPrint(*debugPtr, "Value: "+value)

	item := map[string]types.AttributeValue{
		"Key":   &types.AttributeValueMemberS{Value: key},
		"Value": &types.AttributeValueMemberS{Value: value},
	}

	_, err := svc.PutItem(context.TODO(), &dynamodb.PutItemInput{
		TableName: table,
		Item:      item,
		//		ConditionExpression: aws.String("attribute_not_exists(Key)"),
	})
	if err != nil {
		fmt.Println("failed to add item to table")
		fmt.Println(err)
		os.Exit(1)
	}

	fmt.Println("Added glossary entry for ", key, "in table: ", *table)
}

func printKeyValuePairs(debugPtr *bool, svc *dynamodb.Client, tableName *string, outputFormat *string, fileName *string) {
	// We only print out text, csv, or html
	if *outputFormat != "csv" && *outputFormat != "html" && *outputFormat != "text" {
		fmt.Println("The output format can be csv, html, or text, not " + *outputFormat)
		fmt.Println("Either change the value of Output in config.json or use a -o csv | html | text")
		usage()
		os.Exit(1)
	}

	var entries = getTableItems(debugPtr, svc, tableName, true)

	// create file
	var file2Create string

	switch *outputFormat {
	case "csv":
		file2Create = *fileName + ".csv"
	case "html":
		file2Create = *fileName + ".html"
	case "text":
		file2Create = *fileName + ".txt"
	default:
		fmt.Println("Unrecognized output format: ", *outputFormat)
		os.Exit(1)
	}

	f, err := os.Create(file2Create)
	if err != nil {
		fmt.Println("Could not create")
	}
	// remember to close the file
	defer f.Close()

	var outString string

	if *outputFormat == "html" {
		// If output format is HTML, print preamble
		_, err := f.WriteString("<html>\n  <body>\n")
		if err != nil {
			log.Fatal(err)
		}
	} else if *outputFormat == "csv" {
		_, err := f.WriteString("key,value\n")
		if err != nil {
			log.Fatal(err)
		}
	}

	// Print each glossary entry
	for _, entry := range entries {
		if *outputFormat == "html" {
			// Replace "\n" with "<br/>"
			if entry.Key == "test" {
				DebugPrint(*debugPtr, "Original test value:")
				DebugPrint(*debugPtr, entry.Value)

				origString := entry.Value
				newString := entry.Value
				strings.Replace(newString, "\n", "<br/>", -1)

				if origString != newString {
					DebugPrint(*debugPtr, "Old value: ")
					DebugPrint(*debugPtr, origString)
					DebugPrint(*debugPtr, "New value:")
					DebugPrint(*debugPtr, newString)
				} else {
					DebugPrint(*debugPtr, "The value did not change!")
				}
			}

			outString = "    <p><b>" + entry.Key + "</b>: " + entry.Value + "</p>\n"
		} else if *outputFormat == "csv" {
			outString = entry.Key + "," + entry.Value + "\n"
		} else {
			outString = "Key: " + entry.Key + "\nValue: " + entry.Value + "\n\n"
		}

		_, err = f.WriteString(outString)
		if err != nil {
			log.Fatal(err)
		}
	}

	// If output format is HTML, print closing tags
	if *outputFormat == "html" {
		_, err := f.WriteString("  </body>\n</html>\n")
		if err != nil {
			log.Fatal(err)
		}
	}

	fmt.Println("See output in ", file2Create)
}

func getTableItems(debugPtr *bool, svc *dynamodb.Client, tableName *string, sortIt bool) []Entry {
	if *tableName == "" {
		fmt.Println("You must specify a table name (Table in config.json or -t TABLE)")
		os.Exit(1)
	}

	// Get the table items
	input := &dynamodb.ScanInput{
		TableName: tableName,
	}

	result, err := svc.Scan(context.TODO(), input)
	if err != nil {
		fmt.Println("Error getting table items:")
		fmt.Println(err.Error())
		os.Exit(1)
	}

	// Get table items as an array of glossary entries
	var entries []Entry
	err = attributevalue.UnmarshalListOfMaps(result.Items, &entries)
	if err != nil {
		fmt.Println("Couldn't unmarshal query response")
		fmt.Println(err)
		os.Exit(1)
	}

	if sortIt {
		sort.Slice(entries, func(i, j int) bool {
			return entries[i].Key < entries[j].Key
		})
	}

	return entries
}

func showKeyValuePairs(debugPtr *bool, svc *dynamodb.Client, tableName *string) {
	// Get table items
	var entries = getTableItems(debugPtr, svc, tableName, true)

	fmt.Println("Key")
	fmt.Println("Value")
	fmt.Println()

	// Print each glossary entry
	for _, entry := range entries {
		fmt.Println(entry.Key)
		fmt.Println(entry.Value)
		fmt.Println()
	}
}

func getKeyValue(debugPtr *bool, svc *dynamodb.Client, tableName *string, key string) string {
	// Convert table items into array of glossary entries
	var entries = getTableItems(debugPtr, svc, tableName, false)

	for _, entry := range entries {
		if key == entry.Key {
			return entry.Value
		}
	}

	return ""
}

func removeKeyValuePair(debugPtr *bool, svc *dynamodb.Client, table *string, key string) bool {
	if *table == "" {
		fmt.Println("You must specify a table name (Table in config.json or -t TABLE)")
		os.Exit(1)
	}

	value := getKeyValue(debugPtr, svc, table, key)

	if value == "" {
		fmt.Println("The key does not exist")
		return false
	}

	item := map[string]types.AttributeValue{
		"Key":   &types.AttributeValueMemberS{Value: key},
		"Value": &types.AttributeValueMemberS{Value: value},
	}

	_, err := svc.DeleteItem(context.TODO(), &dynamodb.DeleteItemInput{
		TableName: table, Key: item,
	})

	return err == nil
}

func updateValue(debugPtr *bool, svc *dynamodb.Client, tablePtr *string) {
	// Delete it then add it
	// First get key from user
	// Get key name from user
	key := getKeyName(debugPtr, svc)

	didIt := removeKeyValuePair(debugPtr, svc, tablePtr, key)
	if didIt {
		addKeyValuePair(debugPtr, svc, tablePtr, key)
	}
}

func usage() {
	fmt.Println("Command-line options")
	fmt.Println("-d (debug) displays additional information")
	fmt.Println("-h (help)  displays this help information and quits")
	fmt.Println("-t TABLE   overrides the table name in " + configFileName)
	fmt.Println("-o OUTPUT  overrides the output value in " + configFileName)
	fmt.Println("-f OUTPUT  overrides the output file basename value in " + configFileName)
	fmt.Println()
	fmt.Println("Run-time menu:")
	fmt.Println("  c(reate) table")
	fmt.Println("  l(ist) tables")
	fmt.Println("  a(dd) key/value pair to table")
	fmt.Println("  p(rint) key/value pairs")
	fmt.Println("  r(emove) key/value pair")
	fmt.Println("  s(how) key/value pairs")
	fmt.Println("  u(pdate) value for key")
	fmt.Println()
	fmt.Println("  q(uit)")
	fmt.Println()
	fmt.Println("If you don't enter a value, we re-display the menu")
}

func main() {
	debugPtr := flag.Bool("d", false, "Whether to display additionl information")
	helpPtr := flag.Bool("h", false, "Whether to display a help message and quit")
	tablePtr := flag.String("t", "", "The name of the table to create/use")
	outputPtr := flag.String("o", "", "The output format, text or html")
	filePtr := flag.String("f", "", "The basename of the output file")
	flag.Parse()

	if *helpPtr {
		usage()
		os.Exit(0)
	}

	if *debugPtr {
		fmt.Println("Debugging enabled")
	}

	err := populateConfiguration(*debugPtr)
	if err != nil {
		fmt.Println("Got an error populating the configuration:")
		fmt.Println(err)
		os.Exit(1)
	}

	// If either table or output is not set, but is set as global config value is set in config.json,
	// use the global value.
	if *tablePtr == "" {
		*tablePtr = globalConfig.Table
	}

	if *outputPtr == "" {
		*outputPtr = globalConfig.Output
	}

	if *filePtr == "" {
		*filePtr = globalConfig.File
	}

	// Print out config values
	fmt.Println("Table name:           " + *tablePtr)
	fmt.Println("Output format:        " + *outputPtr)
	fmt.Println("Output filename base: " + *filePtr)
	fmt.Println()
	fmt.Println("If these aren't correct, enter q to quit and fix them in config.json")
	fmt.Println("or overwrite them with -t TABLE-NAME -o OUTPUT-FORMAT -f OUTPUT-FILENAME-BASE")
	fmt.Println()
	fmt.Println("Use the -h (help) option for details")
	fmt.Println()

	svc := CreateLocalClient()

	done := false
	var op string

	for {
		fmt.Println("Enter an operation:")
		fmt.Println("  c(reate) table")
		fmt.Println("  l(ist) tables")
		fmt.Println("  a(dd) key/value pair to table")
		fmt.Println("  p(rint) key/value pairs to a file")
		fmt.Println("  r(emove) key/value pair")
		fmt.Println("  s(how) key/value pairs")
		fmt.Println("  u(pdate) value for key")
		fmt.Println("  q(uit)")
		fmt.Println()

		// Get operation from user
		fmt.Scanln(&op)

		if !*debugPtr {
			fmt.Print("\033[H\033[2J") // Clear command window
			println()
		}

		switch op {
		case "c":
			createTable(svc, tablePtr)
		case "l":
			listTables(svc, tablePtr)
		case "a":
			key := getKeyName(debugPtr, svc)
			addKeyValuePair(debugPtr, svc, tablePtr, key)
		case "p":
			printKeyValuePairs(debugPtr, svc, tablePtr, outputPtr, filePtr)
		case "r":
			key := getKeyName(debugPtr, svc)
			removeKeyValuePair(debugPtr, svc, tablePtr, key)
		case "s":
			showKeyValuePairs(debugPtr, svc, tablePtr)
		case "u":
			updateValue(debugPtr, svc, tablePtr)
		case "q":
			done = true
		case "":
			fmt.Println("Since you did not enter a value")
		default:
			fmt.Println("Unrecognized operation: ", op)
		}

		if done {
			break
		}
	}
}
