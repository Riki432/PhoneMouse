PhoneMouse
An app that allows a phone to be used as a mouse.
It has two components, a server file to be executed on the PC or laptop and an android app. 
I don't think it would be very hard to port it to ios but I don't have one so I didn't.
Both the .apk(for the app) and the .exe(for the server) are available in the repo.
Run the server.exe and wait for "The server has started message"
After that open the app and enter the IP address of the system you want to use your phone as a mouse for.
Hit connect and there we go.
The reddish part acts as the LEFT mouse button and the bluish part acts as the RIGHT mouse button.
The entire phone screen acts as the mouse pad.
The position of the mouse cursor is mapped from the phone screen to the system screen in absolutes.
The server uses web hooks to connect to the phone and allow for full duplex communication.
The library used for web hooks is Tornado.
The mouse controlling part is done by pyautogui library.

Finally, the icon was taken from:
www.flaticons.com

That's all folks!
