package main

import (
	"log"
	"os"
	"os/exec"
)

func xdgOpen() {
	cmd := exec.Command("xdg-open", os.Args[1])
	err := cmd.Start()
	if err != nil {
		log.Fatal(err)
	}
}

func main() {
	xdgOpen()
}
