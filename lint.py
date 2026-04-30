#!/usr/bin/env python3
import subprocess
import sys
import json
import os
from glob import glob

QUICKFIX_FILE = "quickfix.vim"

def main():
    print(">>> Running format...")
    command = "docker exec oneview-django-1 poetry run ruff format"
    subprocess.run(
        command.split(' '),
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )

    print(">>> Running lint with fix...")
    command = "docker exec oneview-django-1 poetry run ruff check --fix --output-format json --quiet"
    result = subprocess.run(
        command.split(' '),
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    with open(QUICKFIX_FILE, "w") as file:
        filename = None
        message = None
        # Example error
        # {
        #  'cell': None,
        #  'code': 'F821',
        #  'end_location': {'column': 29, 'row': 31},
        #  'filename': '/app/backend/oneview/graphql/recommendation_builder/set_up_new.py',
        #  'fix': None,
        #  'location': {'column': 25, 'row': 31},
        #  'message': 'Undefined name `UUID`',
        #  'noqa_row': 31,
        #  'severity': 'error',
        #  'url': 'https://docs.astral.sh/ruff/rules/undefined-name'
        #}
        for error in json.loads(result.stdout):
            new_filename = error['filename']
            new_message = error['message']
            if filename and message and filename == new_filename and message == new_message and message.startswith('Undefined name'):
                # deduplicate error message in same file
                # e.g. missing import
                continue
            filename = new_filename
            message = new_message
            row_number = error['location']['row']
            column_number = error['location']['column']

            non_docker_filename = filename.replace('/app/backend/', './saltus/')

            quickfix_line = f"{non_docker_filename}:{row_number}:{column_number}: {message}"

            file.write(quickfix_line + "\n")
            print(quickfix_line)

    print(">>> Running mypy ...")
    command = "docker exec oneview-django-1 poetry run mypy --show-column-numbers --no-error-summary ."
    result = subprocess.run(
        command.split(' '),
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    with open(QUICKFIX_FILE, "a") as file:
        for line in result.stdout.split('/n'):
            error_message = line.replace('oneview/', './saltus/oneview/')
            file.write(error_message)
            print(error_message)

    # TODO: do ctags as well
    # need to write to temp file then overwrite tags file

    files = glob("**/*.py", recursive=True)
    files = [f for f in files if '/migrations/' not in f]
    print(">>> Running ctags ...")
    command = "/opt/homebrew/bin/ctags -f /tmp/tags"
    command_with_python_files = command.split(' ') + files
    result = subprocess.run(
        command_with_python_files,
        text=True,
        # shell is needed for the glob '**/*.py'
        shell=False,
        capture_output = True,
    )
    os.replace("/tmp/tags", "./tags")

if __name__ == "__main__":
    main()
