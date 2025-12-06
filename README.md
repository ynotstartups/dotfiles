# Instructions for setting up a new mac

1. download 1password and log into 1password
1. login to github, add ssh key, clone this repo
1. `./install_mac`
1. install [FiraCode Font](https://github.com/tonsky/FiraCode)

# Crontab

- `crontab -l` to print cron to stdout
- `crontab -e` to edit cron

```
# build oneview ctags every hour
0 * * * * cd __FULL_PATH__ && /opt/homebrew/bin/ctags --recurse --languages=python -f 'tags_temp' && mv 'tags_temp' 'tags' && /usr/bin/touch __FULL_PATH__/cron_run_results/ctags-"$(date)".txt
```
