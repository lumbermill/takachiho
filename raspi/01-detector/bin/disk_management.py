# coding: UTF-8
import os
from os.path import join, relpath
from glob import glob

path = "/"
file_path = os.environ["PROJECT_PATH"]+"/01-detector/storage/picture"
st = os.statvfs(path)

total = st.f_frsize * st.f_blocks
use = st.f_frsize * (st.f_blocks - st.f_bfree)
first_used = float(use) / float(total) * 100
disk_used = float(0.0)

files = [relpath(x, file_path) for x in glob(join(file_path, "*"))]
files.sort()
c = 0
for i in files:
	# キャッシュを無効にするため、os.statvfsを毎回呼び出します。
	st = os.statvfs(path)
	use = st.f_frsize * (st.f_blocks - st.f_bfree)
	disk_used = float(use) / float(total) * 100
	if disk_used >= float(80):
		print (str(c) + "  " + str(i))
		os.remove(str(file_path) + "/" + str(i))
		c += 1
	else:
		break

print "Directory of " + str(c) + " has been removed."
print "Disk usage from " + str(first_used) + "% to " + str(disk_used) + "%."
