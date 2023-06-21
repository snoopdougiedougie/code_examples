package main

import (
	//"bufio"
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"os"

	//"strings"
	"time"

	"github.com/couchbase/gocb/v2"
)

type Config struct {
	Bucket string `json:"Bucket"`
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

/*
func createJsonEntry(key string, value string) string {
	doc := "{ \"Key\": " + key + ", \"Value\": " + value + ", }"

	return doc
}
*/

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

func usage() {
	fmt.Println("Command-line options")
	fmt.Println("-d (debug) displays additional information")
	fmt.Println("-h (help)  displays this help information and quits")
	fmt.Println("-b BUCKET  overrides the bucket name in ", configFileName)
	fmt.Println("-o OUTPUT  overrides the output format value in ", configFileName)
	fmt.Println("           Default: text")
	fmt.Println("-f OUTPUT  overrides the output file basename value in ", configFileName)
	fmt.Println("           DefaultL acronyms")
	fmt.Println()
	fmt.Println("Run-time menu:")
	//fmt.Println("  c(reate) table")
	fmt.Println("  a(dd) key/value pair to bucket")
	fmt.Println("  l(ist) buckets")
	fmt.Println("  p(rint) key/value pairs")
	fmt.Println("  r(emove) key/value pair")
	fmt.Println("  s(how) key/value pairs")
	fmt.Println("  u(pdate) value for key")
	fmt.Println()
	fmt.Println("  q(uit)")
	fmt.Println()
	fmt.Println("If you don't enter a value, we re-display the menu")
}

func ConnectLocalCluster(username string, password string) *gocb.Cluster {
	// From: https://docs.couchbase.com/go-sdk/current/hello-world/start-using-sdk.html
	// Update this to your cluster details
	connectionString := "localhost"

	// For a secure cluster connection, use `couchbases://<your-cluster-ip>` instead.
	cluster, err := gocb.Connect("couchbase://"+connectionString, gocb.ClusterOptions{
		Authenticator: gocb.PasswordAuthenticator{
			Username: username,
			Password: password,
		},
	})
	if err != nil {
		fmt.Println("Could not connect to local cluster. Error:")
		fmt.Println(err)
		os.Exit(1)
	}

	return cluster
}

// Added username and password to call
/*
func ConnectCollection(cluster *gocb.Cluster, bucket *gocb.Bucket, username string, password string) *gocb.Collection {
	// We wait until the bucket is definitely connected and setup.
	err := bucket.WaitUntilReady(5*time.Second, nil)
	if err != nil {
		panic(err)
	}

	// tag::overview[]
	// get a default collection reference
	collection := bucket.DefaultCollection()

	// for a named collection and scope
	//	scope := bucket.Scope("_default")
	//	collection = scope.Collection("_default")


	return collection
}
*/

func GetBucketNames(cluster *gocb.Cluster) []string {
	bucketManager := cluster.Buckets()
	buckets, err := bucketManager.GetAllBuckets(&gocb.GetAllBucketsOptions{})
	if err != nil {
		fmt.Println("Got the following error retrieving list of buckets:")
		fmt.Println(err.Error())
		os.Exit(1)
	}

	bucketList := make([]string, 0)

	for _, b := range buckets {
		bucketList = append(bucketList, b.Name)
	}

	return bucketList
}

func ListBucketNames(cluster *gocb.Cluster) {
	fmt.Println("Buckets:")
	fmt.Println("--------")

	list := GetBucketNames(cluster)

	for _, b := range list {
		fmt.Println(b)
	}

	fmt.Println()
}

/*
func getKeyName(dbgPtr *bool) string {
	// Get key name from user
	fmt.Println("Enter the key name:")
	reader := bufio.NewReader(os.Stdin)
	key, _ := reader.ReadString('\n')
	// convert CRLF to LF
	key = strings.Replace(key, "\n", "", -1)

	DebugPrint(*dbgPtr, "Key: "+key)

	return key
}

func getKeyValueFromUser(dbgPtr *bool) string {
	// Get key value from user
	fmt.Println("Enter the key value:")
	reader := bufio.NewReader(os.Stdin)
	value, _ := reader.ReadString('\n')
	// convert CRLF to LF
	value = strings.Replace(value, "\n", "", -1)

	DebugPrint(*dbgPtr, "Value: "+value)

	return value
}

func addKeyValuePair(dbgPtr *bool, collection *gocb.Collection) error {
	// Create a new key/value pair
	//err := database.Set(key, value)
	key := getKeyName(dbgPtr)
	value := getKeyValueFromUser(dbgPtr)
	_, err := collection.Upsert(key, value, &gocb.UpsertOptions{})
	if err != nil {
		panic(err)
	}

	return err
}
*/

func ShowKeyValuePairs(dbgPtr *bool, bucket *gocb.Bucket) {
	// Perform a N1QL Query
	inventoryScope := bucket.Scope("_default")
	queryResult, err := inventoryScope.Query(
		"SELECT * FROM _default",
		&gocb.QueryOptions{Adhoc: true},
	)
	if err != nil {
		panic(err)
	}

	// Print each found Row
	for queryResult.Next() {
		var result interface{}
		err := queryResult.Row(&result)
		if err != nil {
			panic(err)
		}

		fmt.Println(result)
	}

	if err := queryResult.Err(); err != nil {
		panic(err)
	}
}

func main() {
	// Uncomment following line to enable logging
	// gocb.SetLogger(gocb.VerboseStdioLogger())

	debugPtr := flag.Bool("d", false, "Whether to display additionl information")
	helpPtr := flag.Bool("h", false, "Whether to display a help message and quit")
	bucketPtr := flag.String("b", "", "The name of the bucket to create/use")
	outputPtr := flag.String("o", "", "The output format, text or html")
	filePtr := flag.String("f", "", "The basename of the output file")
	flag.Parse()

	if *helpPtr {
		usage()
		os.Exit(0)
	}

	DebugPrint(*debugPtr, "Debugging enabled")

	// ADDED: Get username and password from environment
	username := os.Getenv("CB_USER")
	password := os.Getenv("CB_PWD")

	DebugPrint(*debugPtr, "User name from environment: "+username)
	DebugPrint(*debugPtr, "Password from environment:  "+password)
	DebugPrint(*debugPtr, "")

	// bucketName := "travel-sample"

	if username == "" || password == "" {
		fmt.Println("You must set the environment variable CB_USER to your user name")
		fmt.Println("and the environment variable CB_PWD to your user's password")
		os.Exit(1)
	}

	err := populateConfiguration(*debugPtr)
	if err != nil {
		fmt.Println("Got an error populating the configuration:")
		fmt.Println(err)
		os.Exit(1)
	}

	// Get the name of the bucket from the command line
	bucketName := *bucketPtr

	// If not supplied, try the config file
	if bucketName == "" {
		bucketName = globalConfig.Bucket
	}

	if bucketName == "" {
		fmt.Println("You must specify the name of a bucket in " + configFileName)
		fmt.Println("or with a -b BUCKET command-line argument")
		os.Exit(1)
	}

	outputFormat := *outputPtr

	if outputFormat == "" {
		outputFormat = globalConfig.Output
	}

	if outputFormat == "" {
		outputFormat = "text"
	}

	fileName := *filePtr

	if fileName == "" {
		fileName = globalConfig.File
	}

	if fileName == "" {
		fileName = "acronyms"
	}

	DebugPrint(*debugPtr, "Bucket: "+bucketName)
	DebugPrint(*debugPtr, "Output: "+outputFormat)
	DebugPrint(*debugPtr, "File:   "+fileName)
	DebugPrint(*debugPtr, "")

	// Connect to the local cluster
	cluster := ConnectLocalCluster(username, password)
	bucket := cluster.Bucket(bucketName)
	// Wait for bucket to be ready
	err = bucket.WaitUntilReady(5*time.Second, nil)
	if err != nil {
		fmt.Println("Got an error waiting for the bucket to be created:")
		fmt.Println(err)
		os.Exit(1)
	}
	//collection := ConnectCollection(cluster, bucket, username, password)

	done := false
	var op string

	for {
		fmt.Println()
		fmt.Println("Enter an operation:")
		fmt.Println("  l(ist) buckets")
		//fmt.Println("  a(dd) key/value pair to bucket")
		//fmt.Println("  p(rint) key/value pairs to a file")
		//fmt.Println("  r(emove) key/value pair")
		//fmt.Println("  s(how) key/value pairs")
		//fmt.Println("  u(pdate) value for key")
		fmt.Println("  q(uit)")
		fmt.Println()

		// Get operation from user
		fmt.Scanln(&op)

		if !*debugPtr {
			fmt.Print("\033[H\033[2J") // Clear command window
			println()
		}

		switch op {
		case "l":
			list := GetBucketNames(cluster)
			for _, b := range list {
				fmt.Println(b)
			}
		case "a":
			fmt.Println("Sorry, this operation is not supported")
			//addKeyValuePair(debugPtr, collection)
		case "p":
			fmt.Println("Sorry, this operation is not supported")
			//printKeyValuePairs(debugPtr, svc, tablePtr, outputPtr, filePtr)
		case "r":
			fmt.Println("Sorry, this operation is not supported")
			//key := getKeyName(debugPtr, svc)
			//removeKeyValuePair(svc, tablePtr, key)
		case "s":
			fmt.Println("Sorry, this operation is not supported")
			//ShowKeyValuePairs(debugPtr, bucket)
		case "u":
			fmt.Println("Sorry, this operation is not supported")
			//updateValue(debugPtr, svc, tablePtr)
		case "q":
			done = true
		case "":
			fmt.Println("You did not enter a value")
		default:
			fmt.Println("Unrecognized operation: ", op)
		}

		if done {
			break
		}
	}

	// Create a new key/value pair
	/*
		key := "my_key"
		value := "my_value"
		err = database.Set(key, value)
		if err != nil {
			// Handle the error
		}
	*/

	// Get the value for the key
	/*
		value, err = database.Get(key)
		if err != nil {
			// Handle the error
		}
	*/

	// Update the value for the key
	/*
		value = "my_new_value"
		err = database.Set(key, value)
		if err != nil {
			// Handle the error
		}
	*/

	// Delete the key/value pair
	/*
		err = database.Delete(key)
		if err != nil {
			// Handle the error
		}
	*/
}
