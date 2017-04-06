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

content = db.audit_spider_update_message.find()

def dealDict(dictData):
	keyList = dictData.keys()
	for key in keyList:
		item = dictData[key]
		if (isinstance(item, (dict))):
			dealDict(item)
		elif (isinstance(item, (str, unicode))):
			newValue = { 'showValue' : item, 'status' : 0}
			dictData[key] = newValue



list = []

print time.time()

for item in content :
	list.append(item)

for item in list :
	temp = item["old_data"]
        item["whole_data"] = temp
        del item["old_data"]
        del item["new_data"]
	#dealDict(temp)
	#temp = item["new_data"]
	#dealDict(temp)

for item in list :
        print item
	#db.for_test.save(item)
	db.audit_spider_update_message.save(item)

print time.time()

#conn = pymongo.Connection("house-be-manage.mongodb",27017)
#db.authenticate("mongouser","Oq3s9rfS8nkYNO")

#db2 = conn.house_audit



