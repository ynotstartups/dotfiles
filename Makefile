SHELL=/bin/zsh

build_notes_website:
	./notes_website.py --private
	./notes_website.py --public

reset_notes_website_hash_and_clear_htmls:
	echo '{}' > 'notes_website_data/.hash_private.json'
	echo '{}' > 'notes_website_data/.hash_public.json'
	rm ../notes/*.html
	rm notes_website_output/*.html

open_local_public_notes_website:
	open ../notes/index.html

deploy_public_notes_website:
	git -C ../notes/ status
	git -C ../notes/ add .
	git -C ../notes/ commit -v
	git -C ../notes/ push

format:
	. .venv/bin/activate; \
		isort **/*.py; black **/*.py

# E501 ignoer line too long: Line too long (82 > 79 characters)
# W503 conflict with black Formatter
lint:
	. .venv/bin/activate; \
		flake8 --ignore=E501,W503,E266 **/*.py | tee quickfix.vim

coverage_test:
	. .venv/bin/activate; \
		coverage run --source . -m pytest vim_python.py test_vim_python.py notes_website.py test_notes_website.py; \
		coverage report --show-missing --omit 'ipython_config.py'

tags:
	ctags **/*.py .vimrc

brew_upgrade_libraries:
	brew update
	brew upgrade
