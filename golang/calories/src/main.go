package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"
	"sort"
	"strconv"
	//	"strings"
)

type Elf struct {
	index    int
	calories int
}

var Elves []Elf

func DebugPrint(debug bool, s string) {
	if debug {
		fmt.Println(s)
	}
}

func usage() {
	fmt.Println("Command-line options")
	fmt.Println("-d (debug) displays additional information")
	fmt.Println("-h (help)  displays this help information and quits")
	fmt.Println("-f INPUT  overrides the input filename value list.txt")
	fmt.Println()
}

func main() {
	debugPtr := flag.Bool("d", false, "Whether to display additionl information")
	helpPtr := flag.Bool("h", false, "Whether to display a help message and quit")
	filePtr := flag.String("f", "list.txt", "The name of the input file")
	flag.Parse()

	if *helpPtr {
		usage()
		os.Exit(0)
	}

	if *debugPtr {
		fmt.Println("Debugging enabled")
		*filePtr = "test.txt"
		fmt.Println()
	}

	f, err := os.OpenFile(*filePtr, os.O_RDONLY, os.ModePerm)
	if err != nil {
		fmt.Println("Could not open file", *filePtr)
		os.Exit(1)
	}
	defer f.Close()

	elves := make([]Elf, 0)
	index := 1

	e := new(Elf)
	e.index = index
	e.calories = 0

	if *debugPtr {
		fmt.Println("Created elf #", e.index, "with", e.calories, "calories")
	}

	sc := bufio.NewScanner(f)

	for sc.Scan() {
		content := sc.Text() // GET the line string
		if content == "" {
			elves = append(elves, *e)

			if *debugPtr {
				fmt.Println("Added elf #", e.index, "with calories: ", e.calories, "to array of elves")
			}

			e = new(Elf)
			index += 1
			e.index = index
			e.calories = 0

			if *debugPtr {
				fmt.Println()
				fmt.Println("Created elf #", e.index, "with", e.calories, "calories")
			}
		} else {
			// It should be an integer
			c, err := strconv.Atoi(content)
			if err != nil {
				fmt.Println("Line was not an integer:")
				fmt.Println(content)
				os.Exit(1)
			}

			if *debugPtr {
				fmt.Println("Adding", c, "calories to elf #", e.index)
			}
			e.calories += c
		}
	}
	if err := sc.Err(); err != nil {
		log.Fatalf("scan file error: %v", err)
		return
	}

	// Add final elf
	elves = append(elves, *e)

	if *debugPtr {
		fmt.Println("Added elf #", e.index, "with calories: ", e.calories, "to array of elves")
	}

	// Sort the array
	sort.Slice(elves, func(i, j int) bool {
		return elves[i].calories > elves[j].calories
	})

	// Print the top of the list
	fmt.Println()
	fmt.Println("Elf", elves[0].index, "had", elves[0].calories, "calories")
	if *debugPtr {
		fmt.Println()
		fmt.Println("This should be #3 with 9 calories")
	}

	if *debugPtr {
		for _, e := range elves {
			fmt.Println("elf #", e.index, "calories: ", e.calories)
		}
		fmt.Println()
	}
}
