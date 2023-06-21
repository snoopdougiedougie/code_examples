package main

import (
	"context"
	"fmt"
	"os"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

/* To list the tables:

   go run main.go
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
	svc := CreateLocalClient()

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
