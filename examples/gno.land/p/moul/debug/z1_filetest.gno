package main

import "gno.land/p/moul/debug"

func main() {
	println("---")
	println(debug.Render(""))
	println("---")
	println(debug.Render("?debug=1"))
	println("---")
}

// Output:
// ---
//
// ---
// <details><summary>debug</summary>
//
// ### Metadata
// | Key | Value |
// | --- | --- |
// | `std.CurrentRealm().PkgPath()` |  |
// | `std.CurrentRealm().Address()` | g1wymu47drhr0kuq2098m792lytgtj2nyx77yrsm |
// | `std.PreviousRealm().PkgPath()` |  |
// | `std.PreviousRealm().Address()` | g1wymu47drhr0kuq2098m792lytgtj2nyx77yrsm |
// | `std.ChainHeight()` | 123 |
// | `time.Now().Format(time.RFC3339)` | 2009-02-13T23:31:30Z |
//
// </details>
//
// ---
