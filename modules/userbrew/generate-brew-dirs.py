#!/bin/python

import os

with open("/etc/passwd", "r") as user_file:
	data = user_file.readlines()
	data_list = data.split(":")
	user = data_list[0]
	uid = data_list[2]
	gid = data_list[3]
	user_dir_path = f"/var/home/.user-brew/{user}"
	os.mkdir(user_dir_path, mode=0o775)
	os.chown(user_dir_path, uid, gid)