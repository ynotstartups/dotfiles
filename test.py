#!/usr/bin/env python3
import subprocess
import sys

def main():
    command = "docker exec -e PYTHONWARNINGS=ignore -e DISABLE_LOGS=1 -e IS_RUNNING_UNITTEST=1 --interactive --tty oneview-django-1 poetry run python manage.py test --keepdb -v 3 --force-color".split(' ')
    # parse 

    print(sys.argv)
    if len(sys.argv) > 2:
        command += sys.argv[1:-1]

    to_test_name = sys.argv[-1]
    # e.g. to_test_name is 'review.py' change to 'test_review.py'
    if to_test_name.endswith('.py') and not to_test_name.startswith('test_'):
        to_test_name = f"test_{to_test_name}"

    if to_test_name.endswith(".py"):
        # testing a file
        command += ['-p', to_test_name]
    else:
        # testing a test case, function or class
        command += ['-k', to_test_name]

    result = subprocess.run(
        command,
        text=True,
    )

    sys.exit(result.returncode)

if __name__ == "__main__":
    main()
