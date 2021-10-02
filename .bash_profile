# installation add the following in .bashrc
# if [ -f ~/.bash_profile ]; then
#     . ~/.bash_profile
# fi

# use vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# use vim mode keymapping in bash shell
set -o vi

# the pattern ** used in a pathname expansion context will match all files and zero or more directories and subdirectories.
shopt -s globstar

alias exteral_monitor="xrandr --output DP2 --auto --output eDP1 --off"
alias internal_monitor="xrandr --output DP2 --off --output eDP1 --auto"

function btspeaker() {
   bluetooth_sink_index=$(pactl list short sinks | grep blue | grep -o ^[1-9]*)
   pactl set-default-sink $bluetooth_sink_index
}

function use_internal_sound_card_sink() {
   # turn off HDMI output
   pactl set-card-profile alsa_card.pci-0000_00_1f.3 off

   # set to use internal sound card sink
   sound_card_sink_index=$(pactl list short sinks | grep alsa | grep -o ^[1-9]*)
   pactl set-default-sink $sound_card_sink_index
}

function earphone() {
   use_internal_sound_card_sink

   # set to use earphone
   sound_card_index=$(pactl list cards | grep -B10 "Apple T2 Audio" | head -n1 | cut -d "#" -f2)
   pactl set-card-profile $sound_card_index output:codec-output+input:codec-input
}

function speaker() {
   use_internal_sound_card_sink

   # set to use speaker
   sound_card_index=$(pactl list cards | grep -B10 "Apple T2 Audio" | head -n1 | cut -d "#" -f2)
   pactl set-card-profile $sound_card_index output:builtin-speaker+input:builtin-mic
}
