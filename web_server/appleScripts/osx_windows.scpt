on GetFrontMost()
	tell application "System Events"
		set activeApp to name of first application process whose frontmost is true
	end tell
	
	return activeApp
end GetFrontMost

on GetWindowsList()
	tell application "System Events"
		local myList
		set myList to {}
		repeat with theProcess in processes
			try
				if not background only of theProcess then
					tell theProcess
						copy name to end of myList
					end tell
				end if
			end try
		end repeat
		return myList
	end tell
end GetWindowsList
