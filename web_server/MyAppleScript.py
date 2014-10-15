import os
import applescript

class MyAppleScript:
  def __new__(cls, *args, **kwargs):
    if not cls._instance:
      cls._instance = super(MyAppleScript, cls).__new__(cls, *args, **kwargs)
    return cls._instance

  def __init__(self):
    script = ""
    cur_file_path = os.path.realpath(__file__)
    cur_dir_path = os.path.dirname(cur_file_path)
    apple_scripts_dir = os.path.join(cur_dir_path,"appleScripts")
    for file_name in os.listdir(apple_scripts_dir):
      full_file_path = os.path.join(apple_scripts_dir, file_name)
      with open (full_file_path, "r") as myfile:
        script = script + myfile.read()
    self.AppleScript = applescript.AppleScript(script)