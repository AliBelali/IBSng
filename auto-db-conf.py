#!/usr/bin/python
import curses
import sys
import os
import stat
import re
import pg

sys.path.append("/usr/local/IBSng")

def getDBConnection():
    from core import db_conf
    reload(db_conf)
    import pg
    con=pg.connect("IBSng",db_conf.DB_HOST,db_conf.DB_PORT,None,None,db_conf.DB_USERNAME,db_conf.DB_PASSWORD)
    return con
		
def doSqlFile(con,file_name):
    content=open(file_name).read(1024*100)
    con.query(content)

con=None
con=getDBConnection()
doSqlFile(con,"/usr/local/IBSng/db/tables.sql")
doSqlFile(con,"/usr/local/IBSng/db/functions.sql")
doSqlFile(con,"/usr/local/IBSng/db/initial.sql")
doSqlFile(con,"/usr/local/IBSng/db/defs.sql")
con.close()

from core.lib import password_lib
password="admin"
passwd_obj=password_lib.Password(password)
con=None
con=getDBConnection()
con.query("update admins set password='%s' where username='system'"%passwd_obj.getMd5Crypt())
con.close()
