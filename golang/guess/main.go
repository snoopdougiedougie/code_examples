package main

import (
	"flag"
	"fmt"
	"math/rand"
	"os"
	"strconv"
	"time"
)

func usage() {
	fmt.Println("go run main.go [-m MAX-NUMBER] [-h] [-d]")
	fmt.Println()
	fmt.Println("where:")
	fmt.Println()
	fmt.Println("  MAX-NUMBER is the maximum value that can be correct.")
	fmt.Println("  The default for MAX-NUMBER is 10.")
	fmt.Println("  -h Prints this help message and quits.")
	fmt.Println("  -d Displays some extra info, such as MAX-NUMBER and the correct answer.")
	fmt.Println()
	fmt.Println("This is a guessing game.")
	fmt.Println("Enter a number between 1 and MAX-NUMBER, or q to quit.")
	fmt.Println("If the guess higher or lower than the correct answer, the game tells you so.")
	fmt.Println("If you guess the correct answer, it tells you how many tries it took and quits.")
}

func dbgPrint(d bool, s string) {
	if d {
		fmt.Println(s)
	}
}

func main() {
	helpPtr := flag.Bool("h", false, "Whether to show the usage info.")
	maxPtr := flag.Int("n", 10, "The max value possible.")
	dbgPtr := flag.Bool("d", false, "Whether to show the random number.")
	flag.Parse()

	if *helpPtr {
		usage()
		os.Exit(0)
	}

	// Get random number from 1 to *maxPtr
	s1 := rand.NewSource(time.Now().UnixNano())
	r1 := rand.New(s1)

	number := r1.Intn(*maxPtr+1) - 1

	dbgPrint(*dbgPtr, "Getting a random number from 1 to "+strconv.Itoa(*maxPtr))
	dbgPrint(*dbgPtr, "Random number: "+strconv.Itoa(number))

	found := false
	guess := ""
	numTries := 0

	// Create random int between 1 and NUMBER

	for !found {
		fmt.Println("Enter a number between 1 and", *maxPtr, "or q to quit:")

		// Taking input from user
		fmt.Scanln(&guess)
		numTries += 1

		dbgPrint(*dbgPtr, "You entered: "+guess)

		if guess == "q" {
			fmt.Println("Sorry you didn't guess the number in", numTries, "tries")
			fmt.Println("The correct number: ", number)
			os.Exit(1)
		}

		// Convert guess from a string to an integer
		num, err := strconv.Atoi(guess)

		if err != nil {
			fmt.Println("BZZZT, you must enter a number or q to quit.")
			continue
		}

		if num < number {
			fmt.Println("Too low. Try again.")
		} else if num > number {
			fmt.Println("Too high. Try again.")
		} else {
			fmt.Println("Correct! You guessed the number in", numTries, "tries")
			found = true
		}
	}
}
