package minisocial

import (
	"std"
	"strings"
	"testing"

	"gno.land/p/demo/testutils" // Provides testing utilities
)

func TestCreatePostSingle(t *testing.T) {
	// Get a test address for alice
	aliceAddr := testutils.TestAddress("alice")
	// TestSetRealm sets the realm caller, in this case Alice
	testing.SetRealm(std.NewUserRealm(aliceAddr))

	text1 := "Hello World!"
	err := CreatePost(text1)
	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}

	// Get the rendered page
	got := Render("")

	// Content should have the text and alice's address in it
	if !(strings.Contains(got, text1) && strings.Contains(got, aliceAddr.String())) {
		t.Fatal("expected render to contain text & alice's address")
	}
}
