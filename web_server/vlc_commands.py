import applescript
from flask import request
from MyAppleScript import *


class vlc_command:
  def __init__(self):
    self.myAppleScript = MyAppleScript()

  def run_command(self, action):
    res = self.get_raw_action(action)
    if action == "GetVolume" or action == "SetVolume":
      return str(float(float(res) / 512))
    return res

  def get_raw_action(self, command):
    return self.myAppleScript.call("VLC_" + command)
