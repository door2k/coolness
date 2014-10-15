import applescript
from flask import request
from MyAppleScript import *


class vlc_command:
  def __init__(self):
    self.myAppleScript = MyAppleScript()

  def run_command(self, action):
    if action == "SetVolume":
      volume = request.args.get('Volume')
      res = self.get_raw_action(action, volume)
    else:
      res = self.get_raw_action(action)

    if action == "GetVolume":
      return str(float(float(res) / 512))

    return res

  def get_raw_action(self, command):
    return self.myAppleScript.call("VLC_" + command)
