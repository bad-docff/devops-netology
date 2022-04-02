package main

import (
	"fmt"
)

func main() {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	var least = x[0]
	for i := range x {
		// fmt.Println(x[i])
		if x[i] < least {
			least = x[i]
		}
	}

	fmt.Println("smallest element: ", least)
}
