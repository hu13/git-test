package main

import (
	"fmt"

	"github.com/jaypipes/ghw"
)

func main() {
	product, err := ghw.Product()
	if err != nil {
		fmt.Printf("Error getting product info: %v", err)
	}

	fmt.Printf("%v\n", product)
}
