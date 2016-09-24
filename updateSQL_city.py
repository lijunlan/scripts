#!/usr/bin/python
# -*- coding: UTF-8 -*-

import MySQLdb

def updateSQL(db, cursor,sql):
	print sql
	try:
		cursor.execute(sql)
		db.commit()
	except BaseException,e:
		print e.args
		db.rollback()

#connect to mysql
db = MySQLdb.connect(host="115.159.67.120", user='vbdev', passwd='vb2015', db='luna_dev', use_unicode=True, charset="utf8")
cursor = db.cursor()

#open file ready to process
file = open("dealedcity.txt")

line = file.readline()
index = 0;
sql = "INSERT INTO luna_city VALUES"
while line:
	sql = sql + "("
	strs = line.split(",")
	if strs[4].strip() == '':
		strs[4] = "NULL"
	sql = sql + strs[0] + "," + strs[1] + ",'" + strs[2] + "'," + strs[3] + "," + strs[4] + "," + strs[5] + ")"
	
	if index > 1000:
		sql = sql + ";"
		print sql
		updateSQL(db,cursor,sql)
		index = 0
		sql = "INSERT INTO luna_city VALUES"
	else:
		sql = sql + ","
		index = index + 1
	line = file.readline()

sql = sql[0:(len(sql) - 1)] + ";"
updateSQL(db,cursor,sql)

file.close()
db.close()

