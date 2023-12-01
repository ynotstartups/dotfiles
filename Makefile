SHELL=/bin/zsh

all: format lint coverage-test

format:
	. .venv/bin/activate; \
		isort **/*.py; black **/*.py

# E501 ignoer line too long: Line too long (82 > 79 characters)
# W503 conflict with black Formatter
lint-python:
	. .venv/bin/activate; \
		flake8 --ignore=E501,W503 **/*.py

lint-vimrc:
	./lint_vimrc.awk .vimrc	

lint-vimrc-open-vim:
	vim -q <(./lint_vimrc.awk .vimrc)

coverage-test:
	. .venv/bin/activate; \
		coverage run --source . -m pytest **/*.py; \
		coverage report --show-missing

tags:
	ctags .vimrc **/*.py *.awk *.md
