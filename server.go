package main

import (
	"fmt"
	"html"
	"log"
	"net/http"
	"os"
)

func main() {
	usernameBytes, err := os.ReadFile("/etc/secret-volume/username")
	if err != nil {
		fmt.Println("Error reading username:", err)
		return
	}
	username := string(usernameBytes)

	passwordBytes, err := os.ReadFile("/etc/secret-volume/password")
	if err != nil {
		fmt.Println("Error reading password:", err)
		return
	}
	password := string(passwordBytes)

	http.HandleFunc("/credential", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "username: %s and password: %s", username, password)
	})

	http.HandleFunc("/hi", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hi")
	})

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
	})

	log.Fatal(http.ListenAndServe(":8080", nil))
}
