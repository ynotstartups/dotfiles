#!/usr/bin/env python3
import re
import sys


FILE_LINE_RE = re.compile(
    r'^\s*File "(?P<file>.+?)", line (?P<line>\d+)(?:, in .+)?'
)

def parse_unittest_output(stream):
    current_file = None
    current_line = None
    collecting_traceback = False
    error_message = None

    for raw_line in stream:
        line = raw_line.rstrip("\n")

        if line.startswith("Traceback"):
            collecting_traceback = True
            current_file = None
            current_line = None
            error_message = None
            continue

        if collecting_traceback:
            m = FILE_LINE_RE.match(line)
            if m:
                current_file = m.group("file")
                current_line = m.group("line")
                continue

            # Final error line (e.g. AssertionError: ...)
            if current_file and current_line and line and not line.startswith(" "):
                file = current_file.replace("/app/backend", "saltus")
                error_message = line.strip()
                yield f"{file}:{current_line}:9: {error_message}"
                collecting_traceback = False


def main():
    if sys.stdin.isatty():
        print("Pipe unittest output into this script.")
        sys.exit(1)

    for qf_line in parse_unittest_output(sys.stdin):
        print(qf_line)


if __name__ == "__main__":
    main()
