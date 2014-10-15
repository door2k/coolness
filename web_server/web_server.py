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

class User:
  def __init__(self, name):
    self.name = name
    self.active_windows_update = threading.Event()
    self.windows_update = threading.Event()
    self.last_time = datetime.datetime.now()



class WebServer(threading.Thread):
  def __init__(self, address = "0.0.0.0"):
    super(WebServer, self).__init__(name="WebServer")
    logger.info("WebServer instance starting up")
    self._stop = threading.Event()

    self.users = {}
    self.daemon = True
    self.address = address
    self.port = 5555
    self.cur_active_window = ""
    self.cur_windows_list = []
    self.myAppleScript = MyAppleScript()
    self.vlc = vlc_command(self.myAppleScript)


  def start_window_watcher(self):
    self.window_watcher_thread = threading.Thread(target=self.update_active_window)
    self.window_watcher_thread.daemon = True
    self.window_watcher_thread.start()
    self.windows_list_watcher_thread = threading.Thread(target=self.update_windows)
    self.windows_list_watcher_thread.daemon = True
    self.windows_list_watcher_thread.start()

  def update_active_window(self):
    print ("window watcher started")
    active_window_res = self.myAppleScript.AppleScript.call('GetFrontMost')
    self.cur_active_window = active_window_res
    while not self.stopped():
      time.sleep(1)
      active_window_res = self.myAppleScript.AppleScript.call('GetFrontMost')
      if self.cur_active_window != active_window_res:
          self.cur_active_window = active_window_res
          for key, value in self.users.iteritems():
            value.active_windows_update.set()
    print("active window watcher stopped")

  def update_windows(self):
    print ("windows watcher started")
    window_res = self.myAppleScript.AppleScript.call('GetWindowsList')
    self.cur_windows_list = window_res
    while not self.stopped():
      time.sleep(3)
      window_res = self.myAppleScript.AppleScript.call('GetWindowsList')
      if self.cur_windows_list != window_res:
          self.cur_windows_list = window_res
          for key, value in self.users.iteritems():
            value.windows_update.set()

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
    for key, value in self.users.iteritems():
      value.active_windows_update.set()
      value.windows_update.set()

    self.stop()
    print "Shutting down server, please wait!(or press ctrl c again)"
    exit(0)

  def shutdown_server(self):
    func = request.environ.get('werkzeug.server.shutdown')
    if func is None:
        raise RuntimeError('Not running with the Werkzeug Server')
    func()

@ws.route('/active_users',methods=['GET'])
def getActiveUsers():
  try:
    global myWs
    res = ""
    for user in myWs.users.values():
      res +=  "{\"" + user.name + "\":\"" + str(user.last_time) + "\"}"
    if res == "":
      res = "\"\""

    return "{\"users\":" + str(res) + "}"
  except Exception,ex:
    print ex.message
    return "{\"users\":\"\"}"

@ws.route('/active_window',methods=['GET'])
def getActiveWindow():
  try:
    global myWs
    user_window = request.args.get('Window')
    user_name = request.args.get('User')
    if not myWs.users.has_key(user_name):
      myWs.users[user_name] = User(user_name)

    if user_window != myWs.cur_active_window :#or user_window != None:
      return str(myWs.cur_active_window)


    myWs.users[user_name].active_windows_update.wait()
    myWs.users[user_name].active_windows_update.clear()
    myWs.users[user_name].last_time =  datetime.datetime.now()
    return str(myWs.cur_active_window)
  except Exception,ex:
    print ex.message

@ws.route('/windows_list',methods=['GET'])
def getActiveWindowList():
  try:
    global myWs
    user_name = request.args.get('User')
    if not myWs.users.has_key(user_name):
      myWs.users[user_name] = User(user_name)

    #myWs.users[user_name].windows_update.wait()
    #myWs.users[user_name].windows_update.clear()
    myList = []
    for app in myWs.cur_windows_list:
      myList.append("\"" + app + "\"")
    return "{\"windows\":[" + ','.join(list(myList)) + "]}"
  except Exception,ex:
    print ex.message

@ws.route('/activate',methods=['GET'])
def activate():
  try:
    window = request.args.get('Window')
    global myWs
    active_window_res = myWs.myAppleScript.AppleScript.call('ActivateApp',window)
    return str(active_window_res)
  except Exception,ex:
    print ex.message


last_key_sent = datetime.datetime.now()
last_action = ""
@ws.route('/send_key',methods=['GET'])
def getRequestKey():
  try:
    global last_key_sent, last_action, myWs
    action = request.args.get('Action')
    print(action)
    logger.info(action)
    if (datetime.datetime.now() - last_key_sent).seconds > 5 or last_action != action and action != "SetVolume" and action != "GetVolume":
      #os.system('say ' + action)
      Notifier.notify(action, execute='say ' + action ,activate="org.videolan.vlc", title='Coolness')
      last_key_sent = datetime.datetime.now()
    last_action = action
    vlc_action = myWs.vlc.run_command(action)
    print(vlc_action)
    return vlc_action
  except Exception,ex:
    print ex.message
    return ex.message

myWs = WebServer()
signal.signal(signal.SIGINT,myWs.signal_handler)
myWs.start_window_watcher()

myWs.start()
while True:
  time.sleep(1)
