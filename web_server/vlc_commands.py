from flask import request
from MyAppleScript import *


class vlc_command:
  def __init__(self, appleScript):
    self.myAppleScript = appleScript

  def run_command(self, action):
    if action == "SetVolume":
      volume = request.args.get('Volume')
      res = self.get_raw_action2(action, float(volume) * 256)
      return str(float(float(res) / 256))
    elif action == "GetVolume":
      res = self.get_raw_action(action)
      return str(float(float(res) / 256))
    else:
      res = self.get_raw_action(action)


    return res

  def get_raw_action(self, command):
    return self.myAppleScript.AppleScript.call("VLC_" + command)
  def get_raw_action2(self, command, arg):
    return self.myAppleScript.AppleScript.call("VLC_" + command, arg)
