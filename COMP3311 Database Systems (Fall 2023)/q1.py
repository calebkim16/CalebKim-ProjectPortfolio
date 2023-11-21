#!/usr/bin/python3
# COMP3311 23T3 Ass2 ... track proportion of overseas students

import sys
import psycopg2
import re

# define any local helper functions here
# ...

### set up some globals
term_counts = {}
local_counts = {}
international_counts = {}

### process command-line args


try:
  with psycopg2.connect('dbname=ass2') as conn:
    with conn.cursor() as db:

  # show term, #locals, #internationals, fraction

  # ... add your code here ...
      db.execute('''
      SELECT DISCTINCT s.STATUS, s.id, t.code
      FROM Students s
      JOIN Program_enrolments pe ON (s.id = pe.student)
      JOIN Terms t ON (t.id = pe.term)
      WHERE t.code BETWEEN '19T1' AND '23T3'
      ''')

      for tuple in db.fetchall():
        status, id, term_code = tuple
        if term_code  not in term_counts:
          term_counts[term_code] = 0
          local_counts[term_code] = 0
          international_counts[term_code] = 0

        term_counts[term_code] += 1

        if status == 'INTL':
          international_counts[term_code] += 1
        else:
          local_counts[term_code] += 1

      print("Term   #Locl    #Intl    Proportion")

  for term_code in sorted(term_counts.keys()):
    locals_count = local_counts[term_code]
    international_count = international_counts[term_code]

    if international_count == 0:
        proportion = 0.0
    else:
        proportion = locals_count / international_count

    print(f"{term_code}   {locals_count:6d}   {international_count:6d}   {proportion:6.1f}")

except Exception as err:
  print(err)
finally:
  if db:
    db.close()