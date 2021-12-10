#!/usr/bin/env python3
"""
copy last edited file to format `date.extension`
"""

import glob
import os
from datetime import date
import shutil

# TODO: this seems to return directory too
list_directory = glob.glob('./*')
list_of_files = [f for f in list_directory if os.path.isfile(f)]
latest_file = max(list_of_files, key=os.path.getmtime)

_, file_extension = os.path.splitext(latest_file)

print(latest_file)

today_date_filename = os.path.join(".", f"{date.today()}{file_extension}")

print(today_date_filename)

print(f"copying {latest_file} to {today_date_filename}")

# shutil.copy(latest_file, today_date_filename)

