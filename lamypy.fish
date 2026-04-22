set docker_to_local_path_s_command 's;^|^[.][/];saltus/;1'
echo "" > quickfix.vim
echo '>>> Running mypy...'
docker exec oneview-django-1 poetry run mypy . 2>&1 | sed -E $docker_to_local_path_s_command | tee -a quickfix.vim
