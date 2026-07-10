#!/bin/bash
sel=$(ps aux | /home/hamad/.local/bin/dmenu -c -l 20 -p 'Kill:' -fn 'Iosevka Nerd Font Mono-14' -nb '#011628' -nf '#CBE0F0' -sb '#143652' -sf '#2CF9ED' | awk '{print $2}')
[[ -n "$sel" ]] && kill "$sel"
