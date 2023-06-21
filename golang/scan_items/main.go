package main

import (
	"context"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"

	"flag"
	"fmt"
	"os"
)

// Entry defines the glossary entries for the table
type Entry struct {
	Key   string
	Value string
}

func usage() {
	fmt.Println("Usage:")
	fmt.Println("  go run main.go [-h] [-d] [-o OUTPUT] -t TABLE")
	fmt.Println("")
	fmt.Println("-d gives you extra, debugging info")
	fmt.Println("")
	fmt.Println("-h displays this message and quits")
	fmt.Println("")
	fmt.Println("OUTPUT prints output in either text (-o text) or HTML (-o html)")
	fmt.Println("the default is text")
	fmt.Println("")
	fmt.Println("TABLE is required")
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

func main() {
	debugPtr := flag.Bool("d", false, "Barf out additional info")
	helpPtr := flag.Bool("h", false, "Show help and quit")
	outPtr := flag.String("o", "text", "Output format")
	tablePtr := flag.String("t", "", "The name of the table")
	flag.Parse()

	if *helpPtr {
		usage()
		os.Exit(0)
	}

	if *debugPtr {
		fmt.Println("Debugging is enabled")
		fmt.Println("Output format: ", *outPtr)
	}

	table := *tablePtr

	if table == "" {
		fmt.Println("You must supply a table name")
		usage()
		os.Exit(1)
	}

	// Create local DynamoDB client
	svc := CreateLocalClient()

	// Get the table items
	input := &dynamodb.ScanInput{
		TableName: tablePtr,
	}

	result, err := svc.Scan(context.TODO(), input)
	if err != nil {
		fmt.Println("Error getting table items:")
		fmt.Println(err.Error())
		os.Exit(1)
	}

	if *debugPtr {
		fmt.Println("Got", result.ScannedCount, "entries")
	}

	// Convert table items into array of glossary entries
	var entries []Entry
	err = attributevalue.UnmarshalListOfMaps(result.Items, &entries)
	if err != nil {
		fmt.Println("Couldn't unmarshal query response")
		fmt.Println(err)
		os.Exit(1)
	}

	if *debugPtr {
		fmt.Println("Got")
	}

	// If output format is HTML, print preamble
	if *outPtr == "html" {
		fmt.Println("<html>")
		fmt.Println("  <body>")
	}

	// Show each glossary entry
	for _, entry := range entries {
		if *outPtr == "html" {
			fmt.Print("    <p><b>", entry.Key, "</b>: ", entry.Value, "</p>")
		} else {
			fmt.Println("Key: ", entry.Key, " Value: ", entry.Value)
		}
	}

	// If output format is HTML, print closing tags
	if *outPtr == "html" {
		fmt.Println("  <body>")
		fmt.Println("<html>")
	}
}
