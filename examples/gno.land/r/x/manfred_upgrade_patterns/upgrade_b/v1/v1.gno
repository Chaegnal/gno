package upgradea

import "std"

const admin = "blahblah"

var (
	counter     int
	nextVersion string
)

func Inc(nb int) {
	if nextVersion != "" {
		panic("contract is locked, please use the new version at r/" + nextVersion)
	}
	counter += nb
}

func Get() int {
	return counter
}

func SetNextVersion(addr string) {
	// assert CallTx call.
	std.AssertOriginCall()
	// assert admin.
	caller := std.CallerAt(2)
	if caller != std.OriginCaller() {
		panic("should not happen") // because std.AssertOriginCall().
	}
	if caller != admin {
		panic("unauthorized")
	}
	nextVersion = addr
}
