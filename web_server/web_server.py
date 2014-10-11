import os
import threading
import applescript
import AppKit
from flask import Flask, request, logging
from pync import Notifier
import time
import sys
import signal
from vlc_commands import *


ws = Flask(__name__)
cur_active_window = ""
logger = logging.getLogger(__name__)
class WebServer(threading.Thread):
  def __init__(self, address = "0.0.0.0"):
    super(WebServer, self).__init__(name="WebServer")
    logger.info("WebServer instance starting up")
    self._stop = threading.Event()
    self.daemon = True
    self.address = address
    self.port = 5555

  def run(self):
    global ws
    self.started = True
    ws.run(self.address, self.port, use_reloader = False, threaded=True)

  def non_threaded_run(self):
    global ws
    self.started = True
    ws.run(self.address, self.port, use_reloader = False, threaded=True)

  def stop(self):
    #self.shutdown_server()
    self._stop.set()
    self._Thread__stop()

  def stopped(self):
    return self._stop.isSet()

  def signal_handler(self, signal, frame):
    print('You pressed Ctrl+C!')
    self.stop()
    print "Shutting down server, please wait!(or press ctrl c again)"
    exit(0)

  def shutdown_server(self):
    func = request.environ.get('werkzeug.server.shutdown')
    if func is None:
        raise RuntimeError('Not running with the Werkzeug Server')
    func()
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
  try:
    global cur_active_window

    scpt = applescript.AppleScript('''
     tell application "System Events"
          set activeApp to name of first application process whose frontmost is true
      end tell

      return activeApp
    ''')

    #print(scpt.run()) #-> 1
    count = 0
    active_window_res = scpt.run()
    #print (active_window_res)
    while cur_active_window == active_window_res and  count < 10:
      time.sleep(1)
      active_window_res = scpt.run()
      #print(active_window_res)
      count+=1

    cur_active_window = active_window_res
    return cur_active_window
  except Exception,ex:
    return ex.message

@ws.route('/send_key',methods=['GET'])
def getRequestKey():
  try:
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
    vlc = vlc_command()
    vlc_action = vlc.get_command(action)
    print(vlc_action)
    sc = applescript.AppleScript(vlc_action).run()
    print(sc)
    return sc
  except Exception,ex:
    return ex.message


myWs = WebServer()
signal.signal(signal.SIGINT,myWs.signal_handler)
myWs.run()

while True:
  time.sleep(1)