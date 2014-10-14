import os
import threading
import datetime

from flask import Flask, request, logging
from pync import Notifier
import time
import signal
from vlc_commands import *

ws = Flask(__name__)
logger = logging.getLogger(__name__)
class WebServer(threading.Thread):
  def __init__(self, address = "0.0.0.0"):
    super(WebServer, self).__init__(name="WebServer")
    logger.info("WebServer instance starting up")
    self._stop = threading.Event()

    self.active_windows_update = threading.Event()
    self.windows_update = threading.Event()

    self.active_windows_update.clear()
    self.windows_update.clear()

    self.daemon = True
    self.address = address
    self.port = 5555
    self.cur_active_window = ""
    self.cur_windows_list = []


  def start_window_watcher(self):
    self.window_watcher_thread = threading.Thread(target=self.update_active_window)
    self.window_watcher_thread.daemon = True
    self.window_watcher_thread.start()
    self.windows_list_watcher_thread = threading.Thread(target=self.update_windows)
    self.windows_list_watcher_thread.daemon = True
    self.windows_list_watcher_thread.start()

  def update_active_window(self):
    print ("window watcher started")
    scpt = applescript.AppleScript('''
     tell application "System Events"
          set activeApp to name of first application process whose frontmost is true
      end tell

      return activeApp
    ''')
    active_window_res = scpt.run()
    self.cur_active_window = active_window_res
    while not self.stopped():
      time.sleep(1)
      self.active_windows_update.clear()
      active_window_res = scpt.run()
      if self.cur_active_window != active_window_res:
          self.cur_active_window = active_window_res
          self.active_windows_update.set()
    print("active window watcher stopped")

  def update_windows(self):
    print ("windows watcher started")
    scpt = applescript.AppleScript('''
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
    end tell''')
    window_res = scpt.run()
    self.cur_windows_list = window_res
    while not self.stopped():
      time.sleep(3)
      self.windows_update.clear()
      window_res = scpt.run()
      if self.cur_windows_list != window_res:
          self.cur_windows_list = window_res
          self.windows_update.set()

    print("windows watcher stopped")

  def run(self):
    global ws
    ws.run(self.address, self.port, threaded=True)

  def stop(self):
    #self.shutdown_server()
    self._stop.set()
    self._Thread__stop()
    self.join()

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


@ws.route('/active_window',methods=['GET'])
def getActiveWindow():
  try:
    global myWs
    user_window = request.args.get('window')

    if user_window != myWs.cur_active_window :#or user_window != None:
      return myWs.cur_active_window

    myWs.active_windows_update.wait()
    return myWs.cur_active_window
  except Exception,ex:
    print ex.message

@ws.route('/windows_list',methods=['GET'])
def getActiveWindowList():
  try:
    global myWs
    myWs.windows_update.wait()
    return "{windows:[" + ','.join(list(myWs.cur_windows_list)) + "]}"
  except Exception,ex:
    print ex.message

@ws.route('/activate',methods=['GET'])
def activate():
  try:
    action = request.args.get('action')
    cmd = ('''
    try
      tell application "System Events"
        tell process "%s"
          set frontmost to true
        end tell
      end tell
    on error errMsg
      return errMsg
    end try
    return true''' % action)
    print cmd
    scpt = applescript.AppleScript(cmd).run()
    return scpt
  except Exception,ex:
    print ex.message


last_key_sent = datetime.datetime.now()
last_action = ""
@ws.route('/send_key',methods=['GET'])
def getRequestKey():
  try:
    global last_key_sent, last_action
    action = request.args.get('action')
    print(action)
    logger.info(action)
    if (datetime.datetime.now() - last_key_sent).seconds > 5 or last_action != action:
      os.system('say ' + action)
      #Notifier.notify(action, execute='say ' + action,open='http://github.com/',activate="org.videolan.vlc", title='Coolness')
      Notifier.notify(action, execute='say ' + action ,activate="org.videolan.vlc", title='Coolness')
      #app('System Events').keystroke('N', using=k.command_down)
      last_key_sent = datetime.datetime.now()
    last_action = action
    vlc = vlc_command()
    vlc_action = vlc.run_command(action)
    print(vlc_action)
    return vlc_action
  except Exception,ex:
    print ex.message
    return ex.message

myWs = WebServer()
signal.signal(signal.SIGINT,myWs.signal_handler)
myWs.start_window_watcher()

myWs.start()
raw_input("Press enter to exit...\n\n")

