// main.go

package main

import (
	"fmt"
)

func main() {
	// make an array of strings with 3 elements, and assign it to the variable `names`
	names := []string{"Test", "Bob", "Charlie"}

	// iterate over the names array and print each element
	for _, name := range names {
		fmt.Println(name)
	}
}
