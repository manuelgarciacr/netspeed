# 🛠️ tpm installation

### Placeholder vars for the status bar:
- ### @netspeed-down-_INTERFACE_
- ### @netspeed-down-_INTERFACE_
- ### @netspeed-up-_INTERFACE_
- ### @netspace-up-_INTERFACE_
    ### 📑 .tmux.conf

```bash
set -g @plugin 'tmux-plugins/tpm'
...

# netspeed
set -g @netspeed-interfaces "eno1 wlp3s0"                # Net interfaces to consult 
set -g @netspeed-max-speed-reset-key M                   # Key binding to reset the max speed 
set -g @netspeed-stop-key S                              # Key binding to stop netspeed 
set -g @plugin 'manuelgarciacr/netspeed'

# options
set -g status-position top
set -g status-right '#{@netspeed-down-wlp3s0}'                       # netspeed output placeholders 
set -g status-left '#{@netspeed-down-max-eno1}#{@netspeed-up-eno1}'  # netspeed output placeholders
set -g status-left-length 100                                        # resize if necessary

run '~/.tmux/plugins/tpm/tpm'
```
### C-b I

# 📌 tmux2k integration

1. ### Add tmux2k and netspeed within .tmux.conf and install with C-b I 

    ### 📑 .tmux.conf
```bash
set -g @plugin 'tmux-plugins/tpm'
...

# tmux2k
set -g @plugin '2kabhishek/tmux2k'

# netspeed
set -g @plugin 'manuelgarciacr/netspeed'

# options
set -g status-position top
unbind-key -a

run '~/.tmux/plugins/tpm/tpm'
```
2. ### Copy netspeed/scripts/netspeed2k.sh into .tmux/plugins/tmux2k/plugins
2. ### Modify the OUTPUT var in netspeed2k.sh
3. ### Update .tmux.conf with the desired configuration

    ### 📑 .tmux.conf
```bash
set -g @plugin 'tmux-plugins/tpm'
...

# tmux2k
set -g @tmux2k-bandwidth-network-name "eno1"
set -g @tmux2k-right-plugins "bandwidth netspeed2k"      # netspeed tmux2k plugin
set -g @tmux2k-netspeed2k-colors "light_pink black"      # netspeed color. You can also change directly by editing the main.sh file of the tmux2k plugin
set -g @plugin '2kabhishek/tmux2k'

# netspeed
set -g @netspeed-interfaces "eno1 wlp3s0"
set -g @netspeed-max-speed-reset-key M                   # Key binding to reset the max speed 
set -g @netspeed-stop-key S                              # Key binding to stop netspeed 
set -g @plugin 'manuelgarciacr/netspeed'

# options
set -g status-position top
unbind-key -a

run '~/.tmux/plugins/tpm/tpm'
```
5. ### Refresh the configuration with tmux source ~/.tmux.conf
