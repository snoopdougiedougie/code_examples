package main

import (
	"context"
	"flag"
	"fmt"
	"os"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

/*
To create the glossary entry NAME/DEFINITION in table TABLE-NAME:

	go run main.go -t TABLE-NAME -n NAME -d DEFINITION
*/
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
	tableName := flag.String("t", "", "The name of the table")
	keyName := flag.String("k", "", "The key for the glossary entry")
	valueName := flag.String("v", "", "The value (definition) for the glossary entry. Don't forget to enclose it in quotes)")
	flag.Parse()

	if *tableName == "" || *keyName == "" || *valueName == "" {
		fmt.Println("You must supply a table name (-t TABLE), key (-k KEY), and value (-v VALUE, where VALUE should be in quotes)")
		return
	}

	svc := CreateLocalClient()

	item := map[string]types.AttributeValue{
		"Key":   &types.AttributeValueMemberS{Value: *keyName},
		"Value": &types.AttributeValueMemberS{Value: *valueName},
	}

	_, err := svc.PutItem(context.TODO(), &dynamodb.PutItemInput{
		TableName: tableName,
		Item:      item,
		//		ConditionExpression: aws.String("attribute_not_exists(Key)"),
	})
	if err != nil {
		fmt.Println("failed to add item to table")
		fmt.Println(err)
		os.Exit(1)
	}

	fmt.Println("Added glossary entry for ", *keyName, "in table: ", *tableName)
}
