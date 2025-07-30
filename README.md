# 🛠️ tpm installation

### Placeholder vars for the status bar:
- ### @netspeed-up-_INTERFACE_
- ### @netspeed-down-_INTERFACE_
- ### @netspeed-updown-_INTERFACE_

    ### 📑 .tmux.conf

```bash
set -g @plugin 'tmux-plugins/tpm'
# ...

# To change an option to its default value, you must eliminate or comment on .tmux.conf, suppress it from 
#   global options (tmux set -gu @netspeed-...) and re-load the configuration (tmux source .tmux.conf)

# netspeed
set -g @netspeed-interfaces "eno1 wlp3s0 unknown"        # Net interfaces to consult 
# set -g @netspeed-max-speed-reset-key J                 # Key binding to reset the max speed. Default M
# set -g @netspeed-max-speed-hide-key K                  # Key binding to hide/show the max speed. Default H 
# set -g @netspeed-stop-key L                            # Key binding to stop/resume netspeed. Default S 
# set -g @netspeed-down-icon                            # download icon. Default 
# set -g @netspeed-up-icon                              # upload icon. Default 
set -g @netspeed-hide-max-speed true                     # hide max speed
set -g @plugin 'manuelgarciacr/netspeed'

# options
unbind-key -a
set -g status-position top
set -g status-style bg=default
set -g status-right '#[bg=lightblue,fg=black]#{@netspeed-updown-wlp3s0}'  # netspeed output placeholders 
set -g status-left '#[bg=lightblue,fg=black]#{@netspeed-down-eno1}'       # netspeed output placeholders
set -ga status-left '#[bg=lightpink]#{@netspeed-up-eno1}'                 # netspeed output placeholders
set -g status-left-length 100                                             # Assign enough length

run '~/.tmux/plugins/tpm/tpm'
```
### Install with C-b I
### To change an option to its default value, you must eliminate or comment on .tmux.conf, suppress it from global options (tmux set -gu @netspeed ...) and re-load the configuration (tmux source .tmux.conf)

# 📌 tmux2k integration

1. ### Add tmux2k and netspeed within .tmux.conf and install with C-b I 

    ### 📑 .tmux.conf
```bash
set -g @plugin 'tmux-plugins/tpm'
# ...

# tmux2k
set -g @plugin '2kabhishek/tmux2k'

# netspeed
set -g @plugin 'manuelgarciacr/netspeed'

# options
unbind-key -a
set -g status-position top

run '~/.tmux/plugins/tpm/tpm'
```
2. ### Copy netspeed/scripts/netspeed2k.sh into .tmux/plugins/tmux2k/plugins
2. ### Modify the OUTPUT var in netspeed2k.sh
3. ### Update .tmux.conf with the desired configuration

    ### 📑 .tmux.conf
```bash
set -g @plugin 'tmux-plugins/tpm'
# ...

# tmux2k
set -g @tmux2k-bandwidth-network-name "eno1"
set -g @tmux2k-right-plugins "bandwidth netspeed2k"      # netspeed tmux2k plugin
set -g @tmux2k-netspeed2k-colors "light_pink black"      # netspeed color. You can also change directly by editing the main.sh file of the tmux2k plugin
set -g @plugin '2kabhishek/tmux2k'

# To change an option to its default value, you must eliminate or comment on .tmux.conf, suppress it from global
#   options (tmux set -gu @netspeed-...) and re-load the configuration (tmux source .tmux.conf)

# netspeed
set -g @netspeed-interfaces "eno1 wlp3s0"
# set -g @netspeed-max-speed-reset-key J                 # Key binding to reset the max speed. Default M
# set -g @netspeed-max-speed-hide-key K                  # Key binding to hide/show the max speed. Default H 
# set -g @netspeed-stop-key L                            # Key binding to stop/resume netspeed. Default S 
set -g @netspeed-down-icon                              # download icon. Default 
set -g @netspeed-up-icon                                # upload icon. Default 
set -g @netspeed-hide-max-speed true                     # hide max speed
set -g @plugin 'manuelgarciacr/netspeed'

# options
unbind-key -a
set -g status-position top

run '~/.tmux/plugins/tpm/tpm'
```
5. ### Refresh the configuration with tmux source ~/.tmux.conf
6. ### To change an option to its default value, you must eliminate or comment on .tmux.conf, suppress it from global options (tmux set -gu @netspeed-...) and re-load the configuration (tmux source .tmux.conf)
