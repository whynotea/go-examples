package main

import (
	"fmt"
	"time"
)

func main() {
	messages := make(chan string)
	go func() { messages <- "ping" }()
	msg := <-messages
	fmt.Println(msg)
	test2()
	time.Sleep(time.Second)
}

func test2() {
	go test1()
}

func test1() {
	fmt.Print("Hello from NBBO\n")
	a, b := 1, 2
	c, d := swap(a, b)
	fmt.Printf("a:%d and b:%d become c:%d and d:%d\n", a, b, c, d)
	typeCheck(true)
	typeCheck(1)
	typeCheck("String")

	s := make([]string, 0, 3)
	fmt.Printf("Type: %T, Length: %d, Capacity: %d\n", s, len(s), cap(s))

	twoD := make([][]int, 2, 3)
	for i := 0; i < len(twoD); i++ {
		twoD[i] = make([]int, 3)
		fmt.Printf("i: %d, len(j):%d\n", i, len(twoD[i]))
	}
	m := make(map[string]int)
	m["tony"] = 40
	m["jane"] = 3
	fmt.Println("map: ", m)
}
func swap(a, b int) (c, d int) {
	c = b
	d = a
	return
}

func typeCheck(i interface{}) {
	switch t := i.(type) {
	case bool:
		fmt.Println("I'm a bool")
	case int:
		fmt.Println("I'm an int")
	default:
		fmt.Printf("I'm of type %T\n", t)
	}
}
