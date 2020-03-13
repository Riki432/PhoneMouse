import pyautogui


maxWidth, maxHeight = pyautogui.size()
currWidth, currHeight = 10, 10
print(maxWidth, maxHeight)
while maxHeight > currHeight:
    pyautogui.moveTo(currWidth, currHeight)
    currWidth += 10
    currHeight += 10
    print(pyautogui.position())