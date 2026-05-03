#!/usr/bin/env python3
"""
Usage:

test.py all
test.py --no-keep-db all

test.py FooTestCase
test.py foo.py
test.py foo_test_case

available flag:
--no-keep-db
--pdb

"""
import subprocess
import sys
import argparse



def main():
    parser = argparse.ArgumentParser(
        prog='python unittest runner',
        description='todo',
    )
    parser.add_argument(
        'testcase',
        nargs='?',
        default=None,
        help='Test module/class/test to run, missing to indicate run all tests'
    )
    parser.add_argument(
        '--no-keep-db',
            action='store_true')  # on/off flag
    parser.add_argument(
        '--pdb',
            action='store_true')  # on/off flag
    args = parser.parse_args()

    command = "docker compose exec -e PYTHONWARNINGS=ignore -e DISABLE_LOGS=1 -e IS_RUNNING_UNITTEST=1 django poetry run python manage.py test --exclude-tag=slow -v 3 --force-color".split(' ')

    if args.pdb:
        command.append("--pdb")

    if args.no_keep_db:
        command.append("--no-input")
    else:
        command.append("--keepdb")

    if to_test_name := args.testcase:
        if to_test_name.endswith('.py') and not to_test_name.startswith('test_'):
            to_test_name = f"test_{to_test_name}"

        if to_test_name.endswith(".py"):
            # testing a file
            command += ['-p', to_test_name]
        else:
            # testing a test case, function or class
            command += ['-k', to_test_name]

    print('>>>Running test:')
    print(" ".join(command))
    result = subprocess.run(command)
    sys.exit(result.returncode)

if __name__ == "__main__":
    main()
