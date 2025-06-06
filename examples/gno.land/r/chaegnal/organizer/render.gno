package organizer

import (
	"std"
	"strconv"

	"gno.land/p/demo/avl/pager"
	"gno.land/p/moul/md"
	"gno.land/p/moul/mdtable"
	"gno.land/p/moul/txlink"
)

const (
	pageSize = 5
)

// displayJoiningStatus displays the joining status for each group if user is logged in
func displayJoiningStatus(group FriendGroup, address std.Address) string {
	var out string

	if address != "" {
		_, ok := group.DAO.IsMember(address)
		if ok {
			out += md.Paragraph("You already are part of this group")
		} else if group.DAO.IsPending(address) {
			out += md.Paragraph("You are awaiting approval for this group")
		} else {
			out += md.Link("Join Group", txlink.Call("AskJoinFriendGroup", "groupId", strconv.Itoa(group.ID))) + "\n\n"
		}
	}

	return out
}

// displayAllExistingGroups displays all the existing group in a pager
// Display primitive informations about them and joining status if logged in
func displayAllExistingGroups(pageNumber, pageSize int, address std.Address) string {
	var out string

	pager := pager.NewPager(ListGroups.Groups, pageSize, false)

	page := pager.GetPage(pageNumber)

	if page.TotalItems == 0 {
		out += "No friend groups available.\n"
		return out
	}

	for _, item := range page.Items {
		group, ok := item.Value.(FriendGroup)
		if !ok {
			continue
		}

		author := NameOrAddress(group.Owner.Owner())

		out += md.H3("Group: "+group.Title+" - By: "+author) + "\n"
		out += md.Paragraph("Number of friends in the group: "+strconv.Itoa(group.DAO.Whitelist.Size())) + "\n"

		out += displayJoiningStatus(group, address)

		out += md.HorizontalRule() + "\n"
	}

	out += page.Picker("/organizer")

	return out
}

// displayGroupInfo display, in a table, the joined group and give the option to see their page or leave the group
// It does not allow pending member to view the group
func displayGroupInfo(group FriendGroup, table *mdtable.Table, hasJoined bool, address std.Address) {
	author := NameOrAddress(group.Owner.Owner())
	var view string

	if hasJoined {
		view = md.Link("View", "/r/chaegnal/organizer/group?groupId="+strconv.Itoa(group.ID)+"&address="+address.String())

		if address != group.Owner.Owner() {
			view += " | " + md.Link("Leave", txlink.Call("LeaveGroup", "groupId", strconv.Itoa(group.ID)))
		}
	} else {
		view = "You cannot view group yet"
	}

	table.Append([]string{group.Title, author, strconv.Itoa(group.DAO.Whitelist.Size()), view})
}

// displayJoinedGroups displays the group joined by the logged in user
func displayJoinedGroups(address std.Address) string {
	var out string
	found := false

	out += md.H2("Your Joined Groups") + "\n"
	table := &mdtable.Table{
		Headers: []string{"Title", "Created By", "Members", "Inspect"},
	}

	ListGroups.Groups.Iterate("", "", func(key string, val any) bool {
		group := val.(FriendGroup)
		//
		_, ok := group.DAO.IsMember(address)
		if ok {
			displayGroupInfo(group, table, true, address)
			found = true
		}

		return false
	})

	if !found {
		out = md.Paragraph("You haven't joined any groups yet.")
	} else {
		out += table.String()
	}

	return out
}

// displayPendingApproval displays the group that the user asked to join but is not yet approved
func displayPendingApproval(address std.Address) string {
	var out string
	found := false

	table := &mdtable.Table{
		Headers: []string{"Title", "Created By", "Members", "Inspect"},
	}

	ListGroups.Groups.Iterate("", "", func(key string, val any) bool {
		group := val.(FriendGroup)
		//
		if group.DAO.IsPending(address) {
			displayGroupInfo(group, table, false, address)
			found = true
		}
		return false
	})

	if !found {
		out = md.Paragraph("No pending join request.")
	} else {
		out += table.String()
	}

	return out
}

func Render(rawURL string) string {
	var out string

	pageNumber, size, err := pager.NewPager(ListGroups.Groups, pageSize, false).ParseQuery(rawURL)
	if err != nil {
		pageNumber = 1
	}

	out += md.H1("Welcome to Friendly Organizer")
	out += md.Paragraph("Here you can join and create FriendGroups to organize your next hangout")

	out += md.HorizontalRule()
	out += md.H2(md.Link("Create New FriendGroup", txlink.Call("CreateFriendGroup", "title", "default")) + "\n\n")
	out += md.HorizontalRule()

	addressStr := parseQuery(rawURL)
	address := std.Address(addressStr)
	out += md.H2("Dashboard")
	if address == "" {
		out += md.Paragraph("Please provide your address in the URL (?address=...) to get a personalized dashboard")
	} else {
		out += displayJoinedGroups(address)
		out += md.H2("Your Pending Request")
		out += displayPendingApproval(address)
	}

	out += md.HorizontalRule()
	out += md.H2("List of FriendGroups")
	out += displayAllExistingGroups(pageNumber, size, address)

	return out
}
