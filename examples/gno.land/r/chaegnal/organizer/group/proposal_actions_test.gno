package group

import (
	"testing"

	"gno.land/p/demo/uassert"
	"gno.land/r/chaegnal/organizer"
)

// Test VoteOnProposal
func Test_VoteOnProposal_Success(t *testing.T) {
	testing.SetOriginCaller("Chaegnal")
	cross(organizer.CreateFriendGroup)("Chaegnal's group")

	CreateProposals("7", "test", "test", "", "", "Chaegnal")

	uassert.NotPanics(t, func() { VoteOnProposal("7", "1", "1", "Chaegnal") })
}

func Test_VoteOnProposal_InvalidVoteId(t *testing.T) {
	testing.SetOriginCaller("Chaegnal")
	cross(organizer.CreateFriendGroup)("Chaegnal's group")

	uassert.PanicsWithMessage(t, "invalid vote id", func() { VoteOnProposal("7", "abc", "1", "Chaegnal") })
}

func Test_VoteOnProposal_InvalidVoteChoice(t *testing.T) {
	testing.SetOriginCaller("Chaegnal")
	cross(organizer.CreateFriendGroup)("Chaegnal's group")

	CreateProposals("7", "test", "test", "", "", "Chaegnal")

	uassert.PanicsWithMessage(t, "invalid vote choice", func() { VoteOnProposal("7", "1", "abc", "Chaegnal") })
}

func Test_VoteOnProposal_NorYayNorNay(t *testing.T) {
	testing.SetOriginCaller("Chaegnal")
	cross(organizer.CreateFriendGroup)("Chaegnal's group")

	CreateProposals("7", "test", "test", "", "", "Chaegnal")

	uassert.PanicsWithMessage(t, "vote should be yay (1) or nay (0)", func() { VoteOnProposal("7", "1", "2", "Chaegnal") })
}

// Test AdminCloseProposal
func Test_AdminCloseProposal_Success(t *testing.T) {
	testing.SetOriginCaller("Chaegnal")
	cross(organizer.CreateFriendGroup)("Chaegnal's group")

	CreateProposals("8", "test", "test", "", "", "Chaegnal")

	uassert.NotPanics(t, func() { AdminCloseProposal("8", "1", "Chaegnal") })
}

func Test_AdminCloseProposal_Failure(t *testing.T) {
	testing.SetOriginCaller("Chaegnal")
	cross(organizer.CreateFriendGroup)("Chaegnal's group")

	CreateProposals("9", "test", "test", "", "", "Chaegnal")

	uassert.PanicsWithMessage(t, "invalid vote id", func() { AdminCloseProposal("9", "a", "Chaegnal") })
}
