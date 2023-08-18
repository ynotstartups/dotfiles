SHELL=/bin/zsh

all: format lint coverage-test

format:
	. .venv/bin/activate; \
		isort **/*.py; black **/*.py

# E501 ignoer line too long: Line too long (82 > 79 characters)
# W503 conflict with black Formatter
lint:
	. .venv/bin/activate; \
		flake8 --ignore=E501,W503 **/*.py

coverage-test:
	. .venv/bin/activate; \
		coverage run --source . -m pytest **/*.py; \
		coverage report --show-missing
