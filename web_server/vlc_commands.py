class vlc_command:
  def __init__(self):
    pass

  def get_command(self,command):
    return """using terms from application "VLC"
		  set info to "Error."
		    %s
		end using terms from""" % self.get_raw_action(command)

  def get_raw_action(self, command):
    if command == "play":
      return self.play()
    if command == "stop":
      return self.stop()
    if command == "pause":
      return self.pause()
    if command == "next":
      return self.next()
    if command == "previous":
      return self.previous()
    if command == "fullscreen":
      return self.fullscreen()
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
				return "Already Paused"
			else
				tell application "VLC" to set fullscreen mode to true
				return "Go into fullscreen"
			end if
		""")