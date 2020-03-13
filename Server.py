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
        
        points = message.split(",")
        if len(points) == 2 and message[:3].isnumeric():
            x = int(float(points[0]))
            y = int(float(points[1]))
            # if self.phone_max_y != -1 and self.phone_max_x != -1:
            fx = map(x, 0, self.phone_max_x, 0, self.screen_x)
            fy = map(y, 0, self.phone_max_y, 0, self.screen_y)
            pyautogui.moveTo(fx, fy)
            # pyautogui.moveRel(fx, fy)

        
        if message == "CLICK":
            pyautogui.click()
        if message == "DBLCLICK":
            pyautogui.doubleClick()
        
        
        if message.startswith("PS:"): #Meaning Phone Screen
            size = message[3:].split(",")
            self.phone_max_x = int(float(size[0]))
            self.phone_max_y = int(float(size[1]))
            return
        
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
    tornado.ioloop.IOLoop.instance().start()


if __name__ == '__main__':
    initiate_server()
