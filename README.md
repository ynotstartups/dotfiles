# Instructions for setting up a new mac

1. download 1password and log into 1password
1. login to github, add ssh key, clone this repo
1. `./install_mac`
1. install [FiraCode Font](https://github.com/tonsky/FiraCode)

# Crontab

- `make cron_print` to print cron to stdout
- `make cron_edit` to edit cron

```bash
# build oneview ctags every 10 minutes
0 * * * * cd __FULL_PATH__ && /opt/homebrew/bin/fd .py | /opt/homebrew/bin/ctags -f tags_temp -L - && mv tags_temp tags && /usr/bin/touch __FULL_PATH__/cron_run_results/ctags-"$(date)".txt
```
