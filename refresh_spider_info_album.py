#!/usr/bin/python
# -*- coding: UTF-8 -*-

from pymongo import MongoClient
import time

#uri = "mongodb://dba:gHAFE*42@jsNmh@10.10.196.7:27017/admin"
#client = MongoClient(uri)
client = MongoClient('10.10.196.7', 27017)

db_auth = client.admin
db_auth.authenticate("dba", "gHAFE*42@jsNmh")

db = client.mydb

#content = db.audit_spider_update_message.find()
content = db.audit_spider.find({'status' : 0})

def dealAlbum(albumList):
	for album in albumList:
		if(album.get("isCover")) :
			album["isCover"] = 0
		#else:
		#	print album.get("isCover")

list = []

oldTime = time.time()

for item in content :
	list.append(item)

for item in list :
	if (item["status"] == 0):
		temp = item["album_data"]
		dealAlbum(temp)
	else:
		print "xxx"	

for item in list :
	if (item["status"] == 0):
#		print item
		db.audit_spider.save(item)

print time.time() - oldTime

#conn = pymongo.Connection("house-be-manage.mongodb",27017)
#db.authenticate("mongouser","Oq3s9rfS8nkYNO")

#db2 = conn.house_audit



