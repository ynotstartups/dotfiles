# Instructions for setting up a new mac

1. download iterm
    - import profile `./Default.json` - Preferences -> Profiles -> Other Actions... -> Import JSON
1. download 1password and log into 1password
1. login to github, add ssh key, clone this repo
1. `./install_mac`
1. install [FiraCode Font](https://github.com/tonsky/FiraCode)

## Firefox Setup

### Move Toolbars at the bottom

Current Profile Folder: `/Users/yuhao.huang/Library/Application Support/Firefox/Profiles/wzhv01wi.default-release/chrome`

- Follow the setup https://github.com/MrOtherGuy/firefox-csshacks
- Use the following code in `userChrome.css`

```css
@import url(chrome/toolbars_below_content.css);
```

- To be able to copy url, the following is needed
    - In `preference` -> `Search`, in `Search Suggestions`, disable all options
      searches, 
    - In `preference` -> `Search`, in `Address Bar`, disable all options
