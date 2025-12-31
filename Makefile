SHELL=/bin/zsh

build_notes_website:
	. .venv/bin/activate; \
		./notes_website.py;

reset_notes_website_hash_and_clear_htmls:
	echo '{}' > 'notes_website_data/.hash_private.json'
	rm ../notes/*.html
	rm notes_website_output/*.html

open_local_public_notes_website:
	open ../notes/index.html

deploy_public_notes_website:
	git -C ../notes/ status
	git -C ../notes/ add .
	git -C ../notes/ commit -v
	git -C ../notes/ push

format_lint_test: format lint test

# `. .venv/bin/activate; \` is required to ensure using executables (such as black)
# in python virtual environments
format:
	. .venv/bin/activate; \
		black **/*.py; \
		isort **/*.py

lint:
	. .venv/bin/activate; \
		flake8 **/*.py | tee quickfix.vim; \
		isort --check-only **/*.py | tee quickfix.vim

test:
	. .venv/bin/activate; \
		coverage run --source . -m pytest --ignore ipython_config.py; \
		coverage report --show-missing --omit 'ipython_config.py'

brew_upgrade_libraries:
	brew update
	brew upgrade

cron_print:
	crontab -l

cron_edit:
	crontab -e
