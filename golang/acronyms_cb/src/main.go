package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
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
	// For a secure cluster connection, use `couchbases://<your-cluster-ip>` instead.
	//connectionString := "localhost"
	cluster, err := gocb.Connect("couchbase://localhost", gocb.ClusterOptions{
		Authenticator: gocb.PasswordAuthenticator{
			Username: username,
			Password: password,
		},
	})
	if err != nil {
		log.Fatal(err)
	}

	return cluster
}

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

func ConnectBucket(cluster *gocb.Cluster, bucketName string) *gocb.Bucket {
	bucket := cluster.Bucket(bucketName)

	err := bucket.WaitUntilReady(5*time.Second, nil)
	if err != nil {
		fmt.Println("Got error trying to connect to bucket " + bucketName + ":")
		fmt.Println(err.Error())
		return nil
	}

	return bucket
}

func createBucket(cluster *gocb.Cluster, bucketName string) error {
	// Get the BucketManager from the cluster
	bucketManager := cluster.Buckets()

	settings := gocb.CreateBucketSettings{BucketSettings: gocb.BucketSettings{Name: bucketName}, ConflictResolutionType: gocb.ConflictResolutionTypeTimestamp}
	//opts := gocb.CreateBucketOptions{}

	err := bucketManager.CreateBucket(settings, nil)
	if err != nil {
		fmt.Println("Error creating primary bucket:", err)
		return err
	}

	// Create a primary index for the bucket
	/*
		_, err = bucketManager.CreatePrimaryIndex("", true, false)
		if err != nil {
			fmt.Println("Error creating primary index:", err)
			return err
		}
	*/
	fmt.Println("Bucket successfully created")
	return nil
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

	// Get CB server user name and password from environment
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

	cluster := ConnectLocalCluster(username, password)

	err := populateConfiguration(*debugPtr)
	if err != nil {
		fmt.Println("Got an error populating the configuration:")
		fmt.Println(err)
		os.Exit(1)
	}

	// Get the name of the bucket
	bucketName := *bucketPtr

	if bucketName == "" {
		bucketName = globalConfig.Bucket
	}

	if bucketName == "" {
		list := GetBucketNames(cluster)
		// If we only have one bucket in the list, use that name
		numBuckets := len(list)
		if numBuckets == 1 {
			bucketName = list[0]
		}
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

	bucket := ConnectBucket(cluster, bucketName)
	if bucket == nil {
		fmt.Println("Try a different bucket name")
		os.Exit(1)
	}

	// Get a reference to the default collection, required for older Couchbase server versions
	// col := bucket.DefaultCollection()

	done := false
	var op string

	for {
		fmt.Println()
		fmt.Println("Enter an operation:")
		//fmt.Println("  c(reate) bucket")
		fmt.Println("  l(ist) buckets CURRENTLY THE ONLY SUPPORTED OPERATION BESIDES Q(UIT)")
		fmt.Println("  a(dd) key/value pair to bucket")
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

		// Every op needs the cluster
		cluster := ConnectLocalCluster(username, password)

		switch op {
		case "c":
			createBucket(cluster, bucketName)
		case "l":
			list := GetBucketNames(cluster)
			for _, b := range list {
				fmt.Println(b)
			}
		case "a":
			//key := getKeyName(debugPtr, svc)
			//addKeyValuePair(debugPtr, svc, tablePtr, key)
		case "p":
			//printKeyValuePairs(debugPtr, svc, tablePtr, outputPtr, filePtr)
		case "r":
			//key := getKeyName(debugPtr, svc)
			//removeKeyValuePair(svc, tablePtr, key)
		case "s":
			//showKeyValuePairs(debugPtr, svc, tablePtr)
		case "u":
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
}
