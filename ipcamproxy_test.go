package main

import (
	"testing"
)

func TestIsUp(t *testing.T) {
	if isUp("localhost", "22") {
	} else {
		t.Errorf("unavaillable site checked but found")
	}

	isUp("localhost_fails", "22")
}

func TestDownloadFromUrl(t *testing.T) {
	downloadFromURL("http://www.gstatic.com:80/webp/gallery3/1.png")
	downloadFromURL("http://fail.png")
}
