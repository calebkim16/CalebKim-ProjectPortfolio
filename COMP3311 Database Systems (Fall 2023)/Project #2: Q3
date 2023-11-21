#!/usr/bin/python3
# COMP3311 23T3 Ass2 ... print list of rules for a program or stream

import sys
import psycopg2
import re
from helpers import getProgram, getStream

# define any local helper functions here
# ...

### set up some globals

usage = f"Usage: {sys.argv[0]} (ProgramCode|StreamCode)"
conn = None

### process command-line args

argc = len(sys.argv)
if argc < 2:
  print(usage)
  exit(1)
code = sys.argv[1]
if len(code) == 4:
  codeOf = "program"
elif len(code) == 6:
  codeOf = "stream"
else:
  print("Invalid code")
  exit(1)

try:
  with psycopg2.connect('dbname=ass2') as conn:
    cursor = conn.cursor()
  if codeOf == "program":
    progInfo = getProgram(conn,code)
    if not progInfo:
      print(f"Invalid program code {code}")
      exit(1)
    qry = '''
      SELECT p.code, p.name FROM Programs p
      WHERE p.code = %s
    '''

    cursor.execute(qry, (code,))
    results = cursor.fetchone()

    programCode, programName = results
    print(f'{programCode}, {programName}')
    print('Academic Requirements:')

    qry2 = '''
      SELECT r.name, r.rtype, r.min_req, r.max_req, r.acadobjs FROM Requirements r
      JOIN Programs p ON (r.for_program = p.id)
      WHERE p.code = %s
      ORDER BY CASE WHEN r.rtype = 'uoc' THEN 1
                    WHEN r.rtype = 'stream' THEN 2
                    WHEN r.rtype = 'core' THEN 3
                    WHEN r.rtype = 'elective' THEN 4
                    WHEN r.rtype = 'gened' THEN 5
                    WHEN r.rtype = 'free' THEN 6
      END
     '''
    cursor.execute(qry2, (code,))
    results = cursor.fetchall()

    for row in results:
      rName, rtype, min_req, max_req, acadobjs = row

      if rtype == 'uoc':
        print(f'Total UOC at least {min_req} UOC')

      if acadobjs is not None:
        newacadobjs = acadobjs.split(',')
        for i in range(len(newacadobjs)):
          acadobjsName = newacadobjs[i]
          qry3 = '''
            SELECT s.name from streams s
            WHERE s.code = %s
            '''
          cursor.execute(qry3, (acadobjsName,))
          results2 = cursor.fetchone()
          if results2:
            newacadobjs[i] = f'{acadobjsName} {results2[0]}'

          qry4 = '''
            SELECT s.title from subjects s
            WHERE s.code  = %s
            '''
          cursor.execute(qry4, (acadobjsName,))
          results3 = cursor.fetchone()
          if results3:
            newacadobjs[i] = f'{acadobjsName} {results3[0]}'

          if '{' in acadobjsName:
            acadobjsName = acadobjsName.strip('{}').split(';')
            acadobjsList = []
            for k in range(len(acadobjsName)):
              acadobjsCode = acadobjsName[k]
              qry6 = '''
                SELECT s.name from streams s
                WHERE s.code = %s
              '''
              cursor.execute(qry6, (acadobjsCode,))
              results6 = cursor.fetchone()
              if results6:
                acadobjsList.append(f'{acadobjsCode} {results6[0]}')

              qry5 = '''
                SELECT s.title from subjects s
                WHERE s.code  = %s
                '''
              cursor.execute(qry5, (acadobjsCode,))
              results5 = cursor.fetchone()
              if results5:
                acadobjsList.append(f'{acadobjsCode} {results5[0]}')
            acadobjsName = "\n or ".join(acadobjsList)

      if rtype == 'stream':
        if min_req is not None:
          print(f'{min_req} stream from {rName}')

        else:
          print(f'all courses from {rName}')

        for acadobjsName in newacadobjs:
          print(f'- {acadobjsName}')

      if rtype == 'core':
        print(f'all courses from {rName}')
        for acadobjsName in newacadobjs:
          print(f'- {acadobjsName}')

      if rtype == 'elective':
        if min_req is not None and max_req is not None and min_req != max_req:
          print(f'between {min_req} and {max_req} UOC courses from {rName}')
          for acadobjsName in newacadobjs:
            print(f'- {acadobjsName}')

        elif min_req is not None and max_req is None:
          print(f'at least {min_req} UOC courses from {rName}')
          for acadobjsName in newacadobjs:
            print(f'- {acadobjsName}')

        elif min_req is None and max_req is not None:
          print(f'up to {max_req} UOC courses from {rName}')
          for acadobjsName in newacadobjs:
            print(f'- {acadobjsName}')

        elif min_req is not None and max_req is not None and min_req == max_req:
          print(f'{min_req} UOC courses from {rName}')
          print(f'- {acadobjs}')

      if rtype == 'gened':
        print(f'{min_req} UOC of {rName}')

      if rtype == 'free':
        if max_req is None:
          print(f'at least {min_req} UOC of {rName}')

        else:
          print(f'{min_req} UOC of {rName}')

##If given stream code
  elif codeOf == "stream":
    strmInfo = getStream(conn,code)
    if not strmInfo:
      print(f"Invalid stream code {code}")
      exit(1)

    cursor = conn.cursor()
    qry = '''
    SELECT s.code, s.name FROM Streams s
    WHERE s.code = %s
    '''

    cursor.execute(qry, (code,))
    results = cursor.fetchone()

    streamCode, streamName = results
    print(f'{streamCode}, {streamName}')
    print('Academic Requirements:')

    qry2 = '''
      SELECT r.name, r.rtype, r.min_req, r.max_req, r.acadobjs FROM Requirements r
      JOIN Streams s ON (r.for_stream = s.id)
      WHERE s.code = %s
      ORDER BY CASE WHEN r.rtype = 'uoc' THEN 1
                    WHEN r.rtype = 'stream' THEN 2
                    WHEN r.rtype = 'core' THEN 3
                    WHEN r.rtype = 'elective' THEN 4
                    WHEN r.rtype = 'gened' THEN 5
                    WHEN r.rtype = 'free' THEN 6
      END
      '''

    cursor.execute(qry2, (code,))
    results = cursor.fetchall()

    for row in results:
      rName, rtype, min_req, max_req, acadobjs = row

      if rtype == 'uoc':
        print(f'Total UOC at least {min_req} UOC')

      if acadobjs is not None:
        newacadobjs = acadobjs.split(',')
        for i in range(len(newacadobjs)):
          acadobjsName = newacadobjs[i]
          qry3 = '''
            SELECT s.name from streams s
            WHERE s.code = %s
            '''
          cursor.execute(qry3, (acadobjsName,))
          results2 = cursor.fetchone()
          if results2:
            newacadobjs[i] = f'{acadobjsName} {results2[0]}'

          qry4 = '''
            SELECT s.title from subjects s
            WHERE s.code  = %s
            '''
          cursor.execute(qry4, (acadobjsName,))
          results3 = cursor.fetchone()
          if results3:
            newacadobjs[i] = f'{acadobjsName} {results3[0]}'

          if '{' in acadobjsName:
            acadobjsName = acadobjsName.strip('{}').split(';')
            acadobjsList = []
            for k in range(len(acadobjsName)):
              acadobjsCode = acadobjsName[k]
              qry6 = '''
                SELECT s.name from streams s
                WHERE s.code = %s
              '''
              cursor.execute(qry6, (acadobjsCode,))
              results6 = cursor.fetchone()
              if results6:
                acadobjsList.append(f'{acadobjsCode} {results6[0]}')

              qry5 = '''
                SELECT s.title from subjects s
                WHERE s.code  = %s
                '''
              cursor.execute(qry5, (acadobjsCode,))
              results5 = cursor.fetchone()
              if results5:
                acadobjsList.append(f'{acadobjsCode} {results5[0]}')
            acadobjsName = "\n or ".join(acadobjsList) 

      if rtype == 'core':
        print(f'all courses from {rName}')
        for acadobjsName in newacadobjs:
          print(f'- {acadobjsName}')

      if rtype == 'elective':
        if min_req is not None and max_req is not None and min_req != max_req:
          print(f'between {min_req} and {max_req} UOC courses from {rName}')
          print(f'- {acadobjs},')

        elif min_req is not None and max_req is None:
          print(f'at least {min_req} UOC courses from {rName}')
          print(f'- {acadobjs},')

        elif min_req is None and max_req is not None:
          print(f'up to {max_req} UOC courses from {rName}')
          print(f'- {acadobjs},')

        elif min_req is not None and max_req is not None and min_req == max_req:
          print(f'{min_req} UOC courses from {rName}')

      if rtype == 'gened':
        print(f'{min_req} UOC of {rName}')

      if rtype == 'free':
        if max_req is None:
          print(f'at least {min_req} UOC of {rName}')

        else:
          print(f'{min_req} UOC of {rName}')

except Exception as err:
  print("DB error: ", err)
finally:
  if conn:
    conn.close()

