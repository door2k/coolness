import datetime
import json
import os
import threading
from flask import Flask, url_for, request, logging
from pync import Notifier


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

  def run(self):
    global ws
    self.started = True
    ws.run(self.address)

  def non_threaded_run(self):
    global ws
    self.started = True
    ws.run(self.address)

  def stop(self):
    self._stop.set()
    self._Thread__stop()

  def stopped(self):
    return self._stop.isSet()


@ws.route('/send_key',methods=['GET'])
def Get_Request_key():
  action = request.args.get('action')
  logger.info(action)
  os.system('say ' + action)
  #Notifier.notify(action, execute='say ' + action,open='http://github.com/',activate="org.videolan.vlc", title='Coolness')
  Notifier.notify(action, execute='say ' + action ,activate="org.videolan.vlc", title='Coolness')
  #app('System Events').keystroke('N', using=k.command_down)
  cmd = """osascript -e '
          tell application "VLC"
            activate
            %s
          end tell'""" % action
  # minimize active window
  os.system(cmd)
  return "Coolness"


myWs = WebServer()
myWs.non_threaded_run()
