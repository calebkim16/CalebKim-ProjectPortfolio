#!/usr/bin/python3
# COMP3311 22T3 Ass2 ... print a transcript for a given student

import sys
import psycopg2
import re
from helpers import getStudent

usage = f"Usage: {sys.argv[0]} zID"
conn = None

### process command-line args

argc = len(sys.argv)
if argc < 2:
  print(usage)
  exit(1)
zid = sys.argv[1]
if zid[0] == 'z':
  zid = zid[1:8]
digits = re.compile("^\d{7}$")
if not digits.match(zid):
  print(f"Invalid student ID {zid}")
  exit(1)

# manipulate database

try:
    with psycopg2.connect('dbname=ass2') as conn:
        cursor = conn.cursor()
        query = '''
        SELECT p.zid, p.family_name, p.given_names, pr.code, st.code, pr.name FROM People p
        JOIN Students s ON (s.id = p.id)
        JOIN Program_enrolments pe ON (pe.student = s.id)
        JOIN Programs pr ON (pe.program = pr.id)
        JOIN Stream_enrolments se ON (se.part_of = pe.id) 
        JOIN Streams st ON (se.stream = st.id)
        WHERE p.zid = %s
        '''

        cursor.execute(query, (zid,))
        info = cursor.fetchone()

        if info:
            zId, lastName, firstName, programCode, streamCode, programName = info
            print(f"{zid} {lastName}, {firstName}")
            print(f"{programCode} {streamCode} {programName}")
        else:
            print(f'Invalid student ID {zid}')
            exit(2)

        qry2 = '''
        SELECT s.code, t.code, s.title, ce.mark, ce.grade, s.uoc FROM Course_enrolments ce
        JOIN Students st ON (st.id = ce.student)
        JOIN People p ON (st.id = p.id)
        JOIN Courses c ON (c.id = ce.course)
        JOIN Subjects s ON (c.subject = s.id)
        JOIN Terms t ON (c.term = t.id)
        WHERE p.zid = %s
        ORDER BY t.code
        '''
        cursor.execute(qry2, (zid,))
        courseInfo = cursor.fetchall()

                total_achieved_uoc = 0
        total_attempted_uoc = 0
        weighted_mark_sum = 0

        for tuple_info in courseInfo:
            courseCode, term, subjectTitle, Mark, Grade, UOC = tuple_info

            #Truncate SubjectTitle to 32 characters
            newsubjectTitle = subjectTitle[:31]

            #Set Mark to '-' if it is None
            Mark = str(Mark) if Mark is not None else "-"

            #Set Grade to '-' if it is None
            Grade = Grade if Grade is not None else "-"

            #Turn UOC from integer to string
            newUOC = str(UOC)

            #UOC Depending on Grade
            if Grade in ['HD', 'DN', 'CR', 'PS', 'XE', 'T']:
                newUOC += 'uoc'
                total_achieved_uoc += UOC
                total_attempted_uoc += UOC

            elif Grade in ['AS', 'AW', 'PW', 'NA', 'RD', 'NF', 'NC', 'LE', 'PE', 'WD', 'WJ']:
                newUOC = 'unrs'

            elif Grade in ['SY', 'EC', 'RC']:
                newUOC += 'uoc'
                total_achieved_uoc += UOC
            else:
                newUOC = 'fail'
                total_attempted_uoc += UOC

            weighted_mark_sum += UOC * (int(Mark) if Mark != '-' else 0)

            print(f"{courseCode} {term} {newsubjectTitle:<32s}{Mark:>3} {Grade:>2s}  {newUOC}")

        WAM = round(weighted_mark_sum / total_attempted_uoc, 1) if total_attempted_uoc != 0 else 0
        print(f'UOC = {total_achieved_uoc}, WAM = {WAM}') 

except Exception as err:
  print("DB error: ", err)
finally:
  if conn:
    conn.close()

