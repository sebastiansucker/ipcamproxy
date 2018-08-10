package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net"
	"net/http"
	"net/url"
	"os"
	"time"
)

var arg string
var debug string
var lastUpdated time.Time
var image []byte

func main() {

	if len(os.Args) > 2 {
		arg = os.Args[1]
		debug = os.Args[2]
	} else {
		log.Println("2 arguments required: URL, debug(true or false)")
		os.Exit(1)
	}

	url, err := url.Parse(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}

	if debug == "true" {
		log.Println("Debug mode - server will run until first request is received")
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {

		diff := time.Now().Sub(lastUpdated)

		if diff > (time.Duration(10)*time.Second) && isUp(url.Hostname(), url.Port()) {
			var err error
			image, err = downloadFromURL(arg)
			if err != nil {
			}
			fmt.Fprint(w, string(image))
		} else {
			fmt.Fprint(w, string(image))
		}

		if debug == "true" {
			os.Exit(0)
		}

	})
	http.ListenAndServe(":9000", nil)
}

func isUp(hostname string, port string) bool {
	conn, err := net.DialTimeout("tcp", hostname+":"+port, time.Duration(1)*time.Second)

	if err != nil {
		return false
	}
	conn.Close()

	return true
}

func downloadFromURL(url string) ([]byte, error) {
	response, err := http.Get(url)
	if err != nil {
		log.Println("Error while downloading", url, "-", err)
		return nil, err
	}
	defer response.Body.Close()

	bs, err := ioutil.ReadAll(response.Body)

	lastUpdated = time.Now()

	return bs, nil
}
