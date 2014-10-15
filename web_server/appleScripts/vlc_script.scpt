on VLC_Play()
	using terms from application "VLC"
		if playing of application "VLC" then
			return "Already Playing"
		else
			tell application "VLC" to play
			return "Playing"
		end if
		
	end using terms from
end VLC_Play

on VLC_Pause()
	using terms from application "VLC"
		if playing of application "VLC" then
			tell application "VLC" to play
			return "Paused"
		else
			return "Already Paused"
		end if
	end using terms from
end VLC_Pause

on VLC_Stop()
	using terms from application "VLC"
		tell application "VLC" to stop
		return "Stopped"
	end using terms from
end VLC_Stop

on VLC_Next()
	using terms from application "VLC"
		
		tell application "VLC" to next
		return "Next"
	end using terms from
end VLC_Next
on VLC_Previous()
	using terms from application "VLC"
		
		tell application "VLC" to previous
		return "Previous"
	end using terms from
end VLC_Previous

on VLC_FullScreen()
	using terms from application "VLC"
		
		if fullscreen mode of application "VLC" then
			tell application "VLC" to set fullscreen mode to false
			return "Went out fullscreen"
		else
			tell application "VLC" to set fullscreen mode to true
			return "Went into fullscreen"
		end if
	end using terms from
end VLC_FullScreen

on VLC_GetVolume()
	using terms from application "VLC"
		tell application "VLC"
			return audio volume
		end tell
	end using terms from
end VLC_GetVolume

on VLC_SetVolume(new_volume)
	using terms from application "VLC"
		tell application "VLC"
			set audio volume to new_volume
			return audio volume
		end tell
	end using terms from
end VLC_SetVolume