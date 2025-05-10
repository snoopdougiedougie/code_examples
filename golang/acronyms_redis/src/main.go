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
	"strings"

	"github.com/redis/go-redis/v9"
)
type Config struct {
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

func debugPrint(debug bool, s string) {
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

func getKeyName() string {
	// Get key name from user
	fmt.Println("Enter the key name:")
	reader := bufio.NewReader(os.Stdin)
	key, _ := reader.ReadString('\n')
	// convert CRLF to LF
	key = strings.Replace(key, "\n", "", -1)

	return key
}

func getKeyValueFromUser() string {
	// Get key value from user
	fmt.Println("Enter the key value:")
	reader := bufio.NewReader(os.Stdin)
	value, _ := reader.ReadString('\n')
	// convert CRLF to LF
	value = strings.Replace(value, "\n", "", -1)

	return value
}

func getKeyValue(rdb *redis.Client, ctx context.Context, key string) string {
	value, err := rdb.Get(ctx, key).Result()
	if err != nil {
		return ""
	}

	return value 
}

func createLocalClient() *redis.Client {
	rdb := redis.NewClient(&redis.Options{
		Addr:     "localhost:6379",
		Password: "", // no password set
		DB:       0,  // use default DB
	})

	return rdb
}

// Prompt user for key and value, then add the new key/value
func addKeyValue(debug bool, rdb *redis.Client, ctx context.Context) {
	key := getKeyName()
	value := getKeyValueFromUser()

	setKeyValue(debug, rdb, ctx, key, value)
}

// Set key/value pair
func setKeyValue(debug bool, rdb *redis.Client, ctx context.Context, key string, value string) {
	debugPrint(debug, "Key: " + key + ", Value: " + value)
	
	err := rdb.Set(ctx, key, value, 0).Err()
	if err != nil {
		fmt.Println("Could not set key", key)
		fmt.Println("Error:")
		fmt.Println(err.Error())
	}
}
	
func printKeysValues(debugPtr bool, rdb *redis.Client, ctx context.Context, outputFormat *string, fileName *string) {
	// We only print out text, csv, or html
	if *outputFormat != "csv" && *outputFormat != "html" && *outputFormat != "text" {
		fmt.Println("The output format can be csv, html, or text, not " + *outputFormat)
		fmt.Println("Either change the value of Output in config.json or use a -o csv | html | text")
		usage()
		os.Exit(1)
	}

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

	// Get the keys/values
	keys := rdb.Keys(ctx, "*")
	numKeys := 0
	
	for _, key := range keys.Val() {
		numKeys += 1
		value := getKeyValue(rdb, ctx, key)
		
		if *outputFormat == "html" {
			outString = "    <p><b>" + key + "</b>: " + value + "</p>\n"
		} else if *outputFormat == "csv" {
			outString = key + "," + value + "\n"
		} else {
			outString = "Key: " + key + " Value: " + value + "\n"
		}

		_, err = f.WriteString(outString)
		if err != nil {
			log.Fatal(err)
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
}

func removeKeyValue(debug bool, rdb *redis.Client, ctx context.Context) {
	key := getKeyName()

	cmd := rdb.Del(ctx, key)
	if cmd.Err() != nil {
		fmt.Println("Could not remove key", key)
	} else {
		debugPrint(debug, "Removed: " + key)
	}
}

func showKeysValues(debug bool, rdb *redis.Client, ctx context.Context) {
	keys := rdb.Keys(ctx, "*")
	numKeys := 0
	
	fmt.Println("Key")
	fmt.Println("Value")
	fmt.Println()
	for _, key := range keys.Val() {
		numKeys += 1
		value := getKeyValue(rdb, ctx, key)
		fmt.Println(key)
		fmt.Println(value)
		fmt.Println()
	}
}

func updateKeyValue(debug bool, rdb *redis.Client, ctx context.Context) {
	// If we have a value for the key, it exists
	key := getKeyName()
	value := getKeyValue(rdb, ctx, key)

	if value == "" {
		println("Key does not exist")
		println()
	} else {
		debugPrint(debug, "Updating key: " + key)
		val := getKeyValueFromUser()
		debugPrint(debug, "From value: "+ value)
		debugPrint(debug, "To value:   " + val)
	
		setKeyValue(debug, rdb, ctx, key, val)
	}
}

func usage() {
	fmt.Println("Command-line options")
	fmt.Println("-d (debug)   displays additional information")
	fmt.Println("-h (help)    displays this help information and quits")
	fmt.Println("-o OUTPUT    overrides the output value in ", configFileName)
	fmt.Println("-f FILENAME  overrides the output file basename value in ", configFileName)
	fmt.Println()
	fmt.Println("Run-time menu:")
	fmt.Println("  a(dd) key/value pair")
	fmt.Println("  p(rint) key/value pairs")
	fmt.Println("  r(emove) key/value pair")
	fmt.Println("  s(how) key/value pairs")
	fmt.Println("  u(pdate) value for key")
	fmt.Println("  q(uit)")
	fmt.Println()
	fmt.Println("If you don't enter a value, we re-display the menu")
}

func main() {
	debugPtr := flag.Bool("d", false, "Whether to display additionl information")
	helpPtr := flag.Bool("h", false, "Whether to display a help message and quit")
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

	var ctx = context.Background()

	if *outputPtr == "" {
		*outputPtr = globalConfig.Output
	}

	if *filePtr == "" {
		*filePtr = globalConfig.File
	}

	// Print out config values
	fmt.Println("Output format:        " + *outputPtr)
	fmt.Println("Output filename base: " + *filePtr)
	fmt.Println()
	fmt.Println("If these aren't correct, enter q to quit and fix them in config.json")
	fmt.Println("or overwrite them with -o OUTPUT-FORMAT -f OUTPUT-FILENAME-BASE")
	fmt.Println()
	fmt.Println("Use the -h (help) option for details")
	fmt.Println()

	rdb := createLocalClient()

	done := false
	var op string

	for {
		fmt.Println("Enter an operation:")
		fmt.Println("  a(dd) key/value pair to table")
		fmt.Println("  p(rint) key/value pairs")
		fmt.Println("  r(emove) key/value pair")
		fmt.Println("  s(how) key/value pairs")
		fmt.Println("  u(pdate) value for key")
		fmt.Println("  q(uit)")
		fmt.Println()

		// Get operation from user
		fmt.Scanln(&op)
		fmt.Println()

		switch op {
		case "a":
			addKeyValue(*debugPtr, rdb, ctx)
		case "p":
			printKeysValues(*debugPtr, rdb, ctx, outputPtr, filePtr)
		case "r":
			removeKeyValue(*debugPtr, rdb, ctx)
		case "s":
			showKeysValues(*debugPtr, rdb, ctx)
		case "u":
			updateKeyValue(*debugPtr, rdb, ctx)
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
