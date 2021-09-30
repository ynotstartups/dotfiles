# installation add the following in .bashrc
# if [ -f ~/.bash_profile ]; then
#     . ~/.bash_profile
# fi

# use vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# use vim mode keymapping in bash shell
set -o vi

alias exteral_monitor="xrandr --output DP2 --auto --output eDP1 --off"
alias internal_monitor="xrandr --output DP2 --off --output eDP1 --auto"

alias earphone="pactl set-card-profile alsa_card.pci-0000_00_1f.3 off && pactl set-card-profile 0 output:codec-output+input:codec-input"
alias speaker="pactl set-card-profile alsa_card.pci-0000_00_1f.3 off && pactl set-card-profile 0 output:builtin-speaker+input:builtin-mic"
