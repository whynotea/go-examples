package main

import (
	"fmt"
	"os"
)

func main() {
	stronglyTyped()
	os.Exit(0)
}

func stronglyTyped() {
	var (
		myInt    = 1
		myDouble = 2.9
	)
	myResult := myInt + int(myDouble)

	fmt.Println("Strongly typed and therefore requiring explicit conversion from double to int:")
	fmt.Printf("%d + %.1f = %d\n", myInt, myDouble, myResult)
}
