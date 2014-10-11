import applescript
from flask import request


class vlc_command:
  def __init__(self):
    pass
  def run_command(self, action):
    cmd = self.get_command(action)
    sc = applescript.AppleScript(cmd).run()
    if action == "GetVolume" or action == "SetVolume":
      return str(float(float(sc) / 512))
    return sc

  def get_command(self,command):
    return """using terms from application "VLC"
		  set info to "Error."
		    %s
		end using terms from""" % self.get_raw_action(command)

  def get_raw_action(self, command):
    if command == "Play":
      return self.play()
    if command == "Stop":
      return self.stop()
    if command == "Pause":
      return self.pause()
    if command == "Next":
      return self.next()
    if command == "Previous":
      return self.previous()
    if command == "Fullscreen":
      return self.fullscreen()
    if command == "GetVolume":
      return self.get_volume()
    if command == "SetVolume":
      return self.set_volume()

    return None


  def play(self):
    return(
    """
			if playing of application "VLC"
				return "Already Playing"
			else
				tell application "VLC" to play
				return "Playing"
			end if
      """)
  def pause(self):
    return (
		"""
			if playing of application "VLC" then
				tell application "VLC" to play
				return "Paused"
			else
				return "Already Paused"
			end if
    """)
  def stop(self):
    return(
		"""
			tell application "VLC" to stop
			return "Stopped"
    """)
  def next(self):
    return (
    """
			tell application "VLC" to next
			return "Next"
		""")
  def previous(self):
    return (
		"""
			tell application "VLC" to previous
			return "Previous"
    """)

  def fullscreen(self):
    return (
		"""
			if fullscreen mode of application "VLC" then
			  tell application "VLC" to set fullscreen mode to false
				return "Went out fullscreen"
			else
				tell application "VLC" to set fullscreen mode to true
				return "Went into fullscreen"
			end if
		""")

  def get_volume(self):
    return ("""
    tell application "VLC"
				return  audio volume
			end tell
		""")

  def set_volume(self):
    volume = request.args.get('Volume')
    new_volume = str(int(float(volume) * 512))
    print new_volume
    return ("""
  	tell application "VLC"
				set audio volume to %s
				return audio volume
			end tell""" % new_volume)
