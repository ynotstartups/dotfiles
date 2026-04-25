#!/usr/bin/env python3
import subprocess
import sys
import json

QUICKFIX_FILE = "quickfix.vim"

def main():
    print(">>> Running ruff check --fix...")
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

    sys.exit(result.returncode)

if __name__ == "__main__":
    main()
