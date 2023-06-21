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
To create the table TABLE-NAME,

	with two fields: name and value, both strings:

	go run main.go -t TABLE-NAME
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
	flag.Parse()

	if *tableName == "" {
		fmt.Println("You must supply a table name (-t TABLE)")
		return
	}

	svc := CreateLocalClient()

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
		TableName:            tableName,
	})
	if err != nil {
		fmt.Println("Could not create table")
		fmt.Println(err)
		os.Exit(1)
	}

	fmt.Println("Created table: ", *tableName)
}
