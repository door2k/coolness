import os
import threading
import applescript
import AppKit
from flask import Flask, request, logging
from pync import Notifier
import time


ws = Flask(__name__)

logger = logging.getLogger(__name__)
class WebServer(threading.Thread):
  def __init__(self, address = "0.0.0.0"):
    super(WebServer, self).__init__(name="WebServer")
    logger.info("WebServer instance starting up")
    self._stop = threading.Event()
    self.daemon = True
    self.started = False
    self.address = address
    self.port = 5555

  def run(self):
    global ws
    self.started = True
    ws.run(self.address, self.port)

  def non_threaded_run(self):
    global ws
    self.started = True
    ws.run(self.address, self.port)

  def stop(self):
    self._stop.set()
    self._Thread__stop()

  def stopped(self):
    return self._stop.isSet()

def bring_to_front():
  action = """tell application "System Events"
  set frontApp to name of first application process whose frontmost is true
  end tell
  tell application frontApp
  if the (count of windows) is not 0 then
    set window_name to name of front window
  end if
  end tell"""
  sample = """property _count : 0

        on run
                set _count to _count + 1

        end run"""

@ws.route('/active_window',methods=['GET'])
def getActiveWindow():
  time.sleep(3)
  scpt = applescript.AppleScript('''
   tell application "System Events"
        set activeApp to name of first application process whose frontmost is true
    end tell

    return activeApp
  ''')

  #print(scpt.run()) #-> 1
  return scpt.run()

@ws.route('/send_key',methods=['GET'])
def getRequestKey():
  action = request.args.get('action')
  logger.info(action)
  os.system('say ' + action)
  #Notifier.notify(action, execute='say ' + action,open='http://github.com/',activate="org.videolan.vlc", title='Coolness')
  Notifier.notify(action, execute='say ' + action ,activate="org.videolan.vlc", title='Coolness')
  #app('System Events').keystroke('N', using=k.command_down)
  cmd = applescript.AppleScript('''
          tell application "VLC"
            activate
            %s
          end tell''' % action)
  # minimize active window
  #os.system(cmd)
  print(cmd.run())
  return "Coolness"


myWs = WebServer()
myWs.non_threaded_run()
