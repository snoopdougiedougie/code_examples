package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"strings"
)

// Keep track of context
type Context struct {
	NumRows   int
	InTable   bool
	HasTitles bool
}

// We get two possible forms of strings:
// If context.HasTitle, a title row, where the row contains headings for the following rows (<th>)
// Data row, which we convert into separate cells (<td>)
func processLine(context Context, s string) Context {
	// If the string ends in a comma, delete it
	s = strings.TrimRight(s, ",")
	parts := strings.Split(s, ",")

	// By default, a row is data
	cellStart := "        <td>"
	cellEnd := "</td>"

	if len(parts) != context.NumRows {
		// We have a new table.
		// Are we currently in a table?
		if context.InTable {
			// Close the current table and start a new one and the first row.
			fmt.Println("    </table>")
			fmt.Println("")
			fmt.Println("    <table>")
			fmt.Println("      <tr>")
		} else {
			// We need to create the table and start the first row.
			fmt.Println("    <table>")
			fmt.Println("      <tr>")
		}

		// Does the table have a title row?
		// If so, make the cell <th> (heading)
		if context.HasTitles {
			cellStart = "        <th>"
			cellEnd = "</th>"
		}
	}

	// Loop through the parts
	for i := 0; i < len(parts); i++ {
		fmt.Println(cellStart + parts[i] + cellEnd)
	}

	fmt.Println("      </tr>")

	context.InTable = true
	context.NumRows = len(parts)
	return context
}

func usage() {
	fmt.Println("go run main.go -f FILE.csv [-t] [-h] ")
	fmt.Println("where:")
	fmt.Println("  FILE.csv is the name of the file containing comma-separated values.")
	fmt.Println("  -t means that if row N+1 has more cells than row N, the first row has titles for the subsequent rows.")
	fmt.Println("  Prints this help message and quits.")
}

func main() {
	filePtr := flag.String("f", "", "The name of the CSV file.")
	titlePtr := flag.Bool("t", false, "Whether each new size of rows has an initial title row")
	helpPtr := flag.Bool("h", false, "Whether to show the usage info")
	flag.Parse()

	if *helpPtr {
		usage()
		os.Exit(0)
	}

	if *filePtr == "" {
		fmt.Println("You must specify a CSV file with -f FILE.csv")
		os.Exit(1)
	}

	context := Context{
		NumRows:   0,
		InTable:   false,
		HasTitles: *titlePtr,
	}

	// Open file and read it line-by-line
	file, err := os.Open(*filePtr)
	if err != nil {
		fmt.Println("Could not open " + *filePtr)
		os.Exit(1)
	}

	// Start html doc with table
	fmt.Println("<html>")
	fmt.Println("  <body>")

	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		txt := scanner.Text()
		context = processLine(context, txt)

		if err := scanner.Err(); err != nil {
			fmt.Println("Got an error reading " + *filePtr)
			file.Close()
			os.Exit(1)
		}
	}

	file.Close()

	// Close html doc
	fmt.Println("  </body>")
	fmt.Println("</html>")
}
