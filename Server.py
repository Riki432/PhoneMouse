'''
    This module hosts a websocket server using tornado
    libraries
'''
import pyautogui
import tornado.web
import tornado.httpserver
import tornado.ioloop
import tornado.websocket as ws
from tornado.options import define, options
import time
# import math

define('port', default=4041, help='port to listen on')

def map(n, start1, end1, start2, end2):
    return ((n - start1)/(end1 - start1)) * (end2 - start2) + start2

pyautogui.PAUSE = 0

def getScrollLabel(value):
    if value <= -2:
        return "<<"
    elif value <= -1:
        return "<"
    elif value <= 0:
        return " "
    elif value <= 1:
        return ">"
    elif value <= 2:
        return ">>"
    return " "

class web_socket_handler(ws.WebSocketHandler):
    '''
    This class handles the websocket channel
    '''
    @classmethod
    def route_urls(cls):
        return [(r'/',cls, {}),]
    
    def simple_init(self):
        self.last = time.time()
        self.stop = False
        self.screen_x, self.screen_y = pyautogui.size() 
        self.phone_max_x, self.phone_max_y = -1, -1
    
    def open(self):
        '''
            client opens a connection
        '''
        self.simple_init()
        print("New client connected")
        self.write_message("You are connected")
        
    def on_message(self, message: str):
        '''
            Message received on the handler
        '''
        # print("Got message " + message)
        # points = message.split(",")
        if message.startswith("UPDATE"):
            points = message.split(":")
            py = int(float(points[1]))
            px = int(float(points[2]))
            sx = map(py, 100, self.phone_max_y, 0, self.screen_x)
            sy = map(px, self.phone_max_x, 0, 0, self.screen_y)
            print("PX {} PY {}".format(px, py))
            print("SX {} SY {}".format(sx, sy))
            pyautogui.moveTo(sx, sy)

        elif message == "LEFTCLICK":
            pyautogui.leftClick()
        elif message == "RIGHTCLICK":
            pyautogui.rightClick()
        elif message.startswith("DBL"):
            if message == "DBL_LEFTCLICK":
                pyautogui.leftClick()
                pyautogui.leftClick()
            elif message == "DBL_RIGHTCLICK":
                pyautogui.rightClick()
                pyautogui.rightClick()
        
        
        elif message.startswith("LONG"):
            # print(message)
            if message.startswith("LONG_PRESS_UPDATE"):
                t = message.split(":")
                newX = int(float(t[1]))
                newY = int(float(t[2]))
                sx = map(newY, 100, self.phone_max_y, 0, self.screen_x)
                sy = map(newX, self.phone_max_x, 0, 0, self.screen_y)
                pyautogui.moveTo(sx, sy)

            elif message == "LONG_PRESS_START":
                print("LONG Press Started")
                pyautogui.mouseDown()

            elif message == "LONG_PRESS_END":
                print("Long Press Ended")
                pyautogui.mouseUp()

        
        elif message.startswith("SCL_START"):
            value = int(float(message.split(":")[1]))
            print("START: " + getScrollLabel(value))
            pyautogui.vscroll(value)
       
        elif message.startswith("PS:"): #Meaning Phone Screen
            size = message[3:].split(",")
            self.phone_max_x = int(float(size[0]))
            self.phone_max_y = int(float(size[1]))
            
        
        # self.write_message("You said {}".format(message))
        # self.last = time.time()
    
    def on_close(self):
        '''
            Channel is closed
        '''
        print("connection is closed")
        self.loop.stop()
    
    def check_origin(self, origin):
        return True

def initiate_server():
    #create a tornado application and provide the urls
    app = tornado.web.Application(web_socket_handler.route_urls())
    
    #setup the server
    server = tornado.httpserver.HTTPServer(app)
    server.listen(options.port)
    
    #start io/event loop
    print("Server has started")
    tornado.ioloop.IOLoop.instance().start()


if __name__ == '__main__':
    initiate_server()
