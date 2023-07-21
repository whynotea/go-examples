package main

import (
	"fmt"

	"github.com/whynotea/go-examples/version"
)

func main() {
	fmt.Print(version.Version.String())
}
