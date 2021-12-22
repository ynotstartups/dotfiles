#!/usr/bin/env python3
"""
copy last edited file to format `date.extension`

TODO:
1. setup test infrastructure and add tests
2. add black
3. add isort
"""

import glob
import os
from datetime import date
import shutil

list_directory = glob.glob('./*')
list_of_files = [f for f in list_directory if os.path.isfile(f)]
latest_file = max(list_of_files, key=os.path.getmtime)

_, file_extension = os.path.splitext(latest_file)

# use [2:] to remove the "20" from year result in 21-12-10.md
today_date_string = str(date.today())[2:]

today_date_filename = os.path.join(".", f"{today_date_string}{file_extension}")

if os.path.exists(today_date_filename):
    print(f"Exiting! destination file {today_date_filename} already exists")
    exit(1)

print(f"copying {latest_file} to {today_date_filename}")
shutil.copy(latest_file, today_date_filename)
