import subprocess
import socket
import os
from datetime import datetime, timedelta
from time import sleep

c = 0
while(c < 30):
    try:
        address = [(s.connect(('8.8.8.8', 80)), s.getsockname()[0], s.close()) for s in [socket.socket(socket.AF_INET, socket.SOCK_DGRAM)]][0][1]
        name = '[%s]' % os.uname()[1]
        time = (datetime.now() + timedelta(hours=9)).strftime("%Y/%m/%d %H:%M:%S")
        cmd = "curl --data 'Host: {n}  Startup time: {t}  IP Address: {a}' 'SLACK_URL'".format(n=name,t=time,a=address)
        print(cmd)
        subprocess.call(cmd, shell=True)
        break
    except:
        c += 1
        sleep(10)
