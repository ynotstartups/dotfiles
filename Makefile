SHELL=/bin/zsh

all: format lint coverage-test

format:
	isort **/*.py
	black **/*.py

lint:
	flake8 --ignore=E501,W503 **/*.py

coverage-test:
	coverage run --source . -m pytest **/*.py
	coverage report --show-missing
