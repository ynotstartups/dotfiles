SHELL=/bin/zsh

all: format lint coverage-test

format:
	. .venv/bin/activate; \
		isort **/*.py; black **/*.py

# E501 ignoer line too long: Line too long (82 > 79 characters)
# W503 conflict with black Formatter
lint:
	. .venv/bin/activate; \
		flake8 --ignore=E501,W503,E266 **/*.py

coverage-test:
	. .venv/bin/activate; \
		coverage run --source . -m pytest vim_python.py test_vim_python.py; \
		coverage report --show-missing --omit 'ipython_config.py'

tags:
	ctags **/*.py .vimrc
