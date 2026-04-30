#!/usr/bin/env python3
import re
import sys

def main():
    # FILE_LINE_RE = re.compile(r'^\s*File "(?P<file>.+?)", line (?P<line>\d+)(?:, in +)?')

    # clear file
    with open("quickfix.vim", "w") as f:
        f.write("")

    collecting_traceback = False

    for raw_line in sys.stdin:
        line = raw_line.rstrip("\n")
        print(line)

        if line.startswith("Traceback"):
            collecting_traceback = True
            error_filename = None
            error_line_number = None
            continue

        if collecting_traceback:
            if line.startswith("  File "):
                # First Error Stack trace on File
                # e.g. File "/app/backend/oneview/tests/graphql/api/test_account.py", line 712, in test_foo
                _, raw_error_filename, _ , raw_line_number, _, testcase_function_name = line.strip().split(' ')

                # raw_error_filename e.g. '"/app/backend/oneview/tests/graphql/api/test_account.py",'
                error_filename = raw_error_filename.replace('"',"").replace(",", "").replace("/app/backend", "saltus")
                # raw_line_number e.g. '712,'
                error_line_number = raw_line_number.replace(",", "")

            if line[0] != " ":
                # last error message line e.g. AssertionError: 1 != 2
                error_message = line.strip()
                with open("quickfix.vim", "a") as f:
                    f.write(f"{error_filename}:{error_line_number}:9: {error_message}\n")

                collecting_traceback = False

if __name__ == "__main__":
    main()
