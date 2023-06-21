package main

import (
	"flag"
	"fmt"
	"time"
)

func f(from string, numIterations uint64) {
	var i uint64 = 0
	for i < numIterations {
		i++
	}

}

const MILLION = 1000000000

func main() {
	iterationPtr := flag.Uint64("i", MILLION, "The number of iterations to run directly or concurrently")
	flag.Parse()

	fmt.Println("Executing", *iterationPtr, "loops.")
	fmt.Println()

	start1 := time.Now()

	f("direct", *iterationPtr)
	duration1 := time.Since(start1)

	fmt.Println("That took:", duration1, "to run synchronously.")
	fmt.Println()

	start2 := time.Now()

	go f("goroutine", *iterationPtr)
	// Wait for a second to ensure all of the threads have returned.
	time.Sleep(time.Second)
	duration2 := time.Since(start2)

	// Correct for the second we waited
	if duration2 > MILLION {
		duration2 -= MILLION
	}

	fmt.Println("That took:", duration2, "to run asynchronously.")
}
