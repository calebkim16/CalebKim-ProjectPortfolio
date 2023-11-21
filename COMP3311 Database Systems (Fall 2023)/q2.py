#!/usr/bin/python3
# COMP3311 23T3 Ass2 ... track satisfaction in a given subject

import sys
import psycopg2
import re

# define any local helper functions here
# ...

### set up some globals

usage = "Usage: {} SubjectCode".format(sys.argv[0])
db = None

### process command-line args

argc = len(sys.argv)
if argc < 2:
  print(usage)
  exit(1)
subject_code  = sys.argv[1]
check = re.compile("^[A-Z]{4}[0-9]{4}$")
if not check.match(subject_code):
  print("Invalid subject code")
  exit(1)

try:
  with psycopg2.connect('dbname=ass2') as conn:
    cursor = conn.cursor()
    query = '''WITH CourseEnrolmentCounts AS (
      SELECT t.code AS term_code, s.code AS subject_code, COUNT(*) AS enrolment_count
      FROM course_enrolments ce
      JOIN Courses c ON (ce.course = c.id)
      JOIN Terms t ON (c.term = t.id)
      JOIN Subjects s ON (c.subject = s.id)
      WHERE s.code = %s AND t.code BETWEEN '19T1' AND '23T3'
      GROUP BY t.code, s.code
      )
      SELECT t.code, c.satisfact, c.nresponses, ce.enrolment_count, p.full_name
      FROM Terms t
      JOIN Courses c ON (t.id = c.term)
      JOIN Program_enrolments pe ON (t.id = pe.term)
      JOIN Subjects s ON (c.subject = s.id)
      JOIN Staff st ON (c.convenor = st.id)
      JOIN People p ON (st.id = p.id)
      LEFT JOIN CourseEnrolmentCounts ce ON t.code = ce.term_code
      WHERE s.code = %s
      GROUP BY t.code, c.satisfact, c.nresponses, p.full_name, ce.term_code, ce.enrolment_count
      ORDER BY t.code ASC
      '''

  cursor.execute(query, (subject_code, subject_code ))
  results = cursor.fetchall()
  print("Term     Satis  #resp  #stu  Convenor")

  for row in results:
    TermCode, Satisfaction, num_responses, count_students, convenor = row
    Satisfaction_str = f"{Satisfaction:6d}" if isinstance(Satisfaction, int) else "     ?   "
    num_responses_str = f"{num_responses:6d}" if isinstance(num_responses, int) else "  ?"
    count_students_str = f"{count_students:6d}" if isinstance(count_students, int) else "     ?"
    print(f"{TermCode} {Satisfaction_str} {num_responses_str} {count_students_str}  {convenor}")

except Exception as err:
  print(err)
finally:
  if cursor:
    cursor.close()

