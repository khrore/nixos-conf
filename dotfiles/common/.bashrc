# bashrc

# Add this lines at the top of .bashrc:
[[ $- == *i* ]] && source "$HOME/.local/share/blesh/ble.sh" --noattach

# Vi mode
set -o vi

eval "$(atuin init bash)"
eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(fzf --bash)"

# Add this line at the end of .bashrc:
[[ ! ${BLE_VERSION-} ]] || ble-attach

. "$HOME/.atuin/bin/env"
. "$HOME/.cargo/env"
