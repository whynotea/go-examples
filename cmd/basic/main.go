package main

import (
	"fmt"
)

var Version = "development"

func main() {
	fmt.Printf("name: %s, version: %s\n", Name(), Version)
}

func Name() string {
	return "Basic"
}
