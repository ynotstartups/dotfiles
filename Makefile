SHELL=/bin/zsh

build_notes_website:
	./notes_website.py

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

format:
	. .venv/bin/activate
	black **/*.py
	isort **/*.py

lint:
	. .venv/bin/activate
	flake8 **/*.py | tee quickfix.vim
	isort --check-only **/*.py | tee quickfix.vim


test:
	. .venv/bin/activate; \
		coverage run --source . -m pytest vim_python.py test_vim_python.py notes_website.py test_notes_website.py; \
		coverage report --show-missing --omit 'ipython_config.py'

tags:
	ctags **/*.py .vimrc

brew_upgrade_libraries:
	brew update
	brew upgrade
