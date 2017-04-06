#!/usr/bin/python
# -*- coding: UTF-8 -*-

import MySQLdb
from pymongo import MongoClient

def executeSQL(db, cursor, sql):
    try:
        result = cursor.execute(sql)
        db.commit()
        return result
    except BaseException,e:
        print e.args
        db.rollback()
        return None


#client = MongoClient('10.10.196.7', 27017)
client = MongoClient('127.0.0.1', 3309)


db_auth = client.admin
#db_auth.authenticate("dba", "gHAFE*42@jsNmh")
db_auth.authenticate("mongouser", "Oq3s9rfS8nkYNO")

mongoDb = client.mydb
mongoDb = client.house_audit

#mysqlDb = MySQLdb.connect(host="10.31.84.120", port=3307, user='fdbuser', passwd='Wslm:11Wps', db='newhouse_shengtai', use_unicode=True, charset="utf8")
mysqlDb = MySQLdb.connect(host="127.0.0.1", port=3308, user='newhouse_rw', passwd='f3ea92d38cc', db='newhouse_shengtai', use_unicode=True, charset="utf8")
cursor = mysqlDb.cursor()

content = mongoDb.audit_spider.find({'status':1})

for item in content:
    pid = item["pid"]
    sql = "SELECT * FROM project WHERE pid=" + str(pid)
    r = executeSQL(mysqlDb, cursor, sql)
    if r == 0:
        print pid


print 'compare finished!'


