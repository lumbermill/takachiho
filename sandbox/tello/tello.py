#
# Based on Tello3.py
#
# USAGE: python3 tello.py demo2.txt
#
# http://www.ryzerobotics.com/
# https://dl-cdn.ryzerobotics.com/downloads/tello/0228/Tello+SDK+Readme.pdf#

import fileinput
import threading
import socket
import sys
import time

host = ''
port = 9000
locaddr = (host,port)

# Create a UDP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

tello_address = ('192.168.10.1', 8889)

sock.bind(locaddr)

def recv():
    count = 0
    while True:
        try:
            data, server = sock.recvfrom(1518)
            print(data.decode(encoding="utf-8"))
        except Exception:
            print ('\nExit . . .\n')
            break

#recvThread create
recvThread = threading.Thread(target=recv)
recvThread.start()

for msg in fileinput.input():
    msg = msg.strip()
    print(msg)
    try:
        if not msg:
            break

        if 'end' in msg:
            print ('...')
            sock.close()
            break

        # Send data
        msg = msg.encode(encoding="utf-8")
        sent = sock.sendto(msg, tello_address)
        time.sleep(3) # TODO: Make it adjustable. and allow comment lines.
    except KeyboardInterrupt:
        print ('\n . . .\n')
        sock.close()
        break
