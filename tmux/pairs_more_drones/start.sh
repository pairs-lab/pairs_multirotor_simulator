#!/bin/bash
# Plain-tmux session script (one window per section below; panes are split and
# their commands typed via send-keys). Edit the send-keys lines to change what
# runs in each pane; ./kill.sh stops everything.

SESSION_NAME=simulation

# absolute path to this script's directory; every pane starts here
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# commands executed first in every pane
PRE_WINDOW='export UAV_NAME=uav1; export RUN_TYPE=simulation; export UAV_TYPE=x500; export BOND=false; export CUSTOM_CONFIG=./config/custom_config.yaml; export WORLD_CONFIG=./config/world_config.yaml; export NETWORK_CONFIG=./config/network_config.yaml; export PLATFORM_CONFIG=`rospack find pairs_multirotor_simulator`/config/pairs_uav_system/$UAV_TYPE.yaml'
SETUP="cd $SCRIPTPATH; $PRE_WINDOW"

if [ -n "$TMUX" ]; then
  echo "Already inside tmux, detach first."
  exit 1
fi

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  echo "Session $SESSION_NAME already exists; attach with 'tmux a -t $SESSION_NAME' or stop it with ./kill.sh."
  exit 1
fi

# ---------------- window: roscore ----------------
read W_roscore P <<< "$(tmux new-session -d -s "$SESSION_NAME" -n "roscore" -x 250 -y 50 -P -F '#{window_id} #{pane_id}')"
tmux send-keys -t "$P" "$SETUP; "'roscore' Enter
tmux select-layout -t "$W_roscore" tiled

# ---------------- window: simulator ----------------
read W_simulator P <<< "$(tmux new-window -t "$SESSION_NAME" -n "simulator" -P -F '#{window_id} #{pane_id}')"
tmux send-keys -t "$P" "$SETUP; "'waitForRos; roslaunch pairs_multirotor_simulator multirotor_simulator.launch custom_config:=./config/simulator.yaml' Enter
tmux select-layout -t "$W_simulator" tiled

# ---------------- window: hw_api ----------------
read W_hw_api P <<< "$(tmux new-window -t "$SESSION_NAME" -n "hw_api" -P -F '#{window_id} #{pane_id}')"
tmux send-keys -t "$P" "$SETUP; "'waitForTime; export UAV_NAME=uav1; roslaunch pairs_multirotor_simulator hw_api.launch custom_config:=./config/hw_api.yaml nodelet_manager_name:=$UAV_NAME\_nodelet_manager' Enter
P=$(tmux split-window -t "$W_hw_api" -P -F '#{pane_id}')
tmux select-layout -t "$W_hw_api" tiled
tmux send-keys -t "$P" "$SETUP; "'waitForTime; export UAV_NAME=uav2; roslaunch pairs_multirotor_simulator hw_api.launch custom_config:=./config/hw_api.yaml nodelet_manager_name:=$UAV_NAME\_nodelet_manager' Enter
P=$(tmux split-window -t "$W_hw_api" -P -F '#{pane_id}')
tmux select-layout -t "$W_hw_api" tiled
tmux send-keys -t "$P" "$SETUP; "'waitForTime; export UAV_NAME=uav3; roslaunch pairs_multirotor_simulator hw_api.launch custom_config:=./config/hw_api.yaml nodelet_manager_name:=$UAV_NAME\_nodelet_manager' Enter
P=$(tmux split-window -t "$W_hw_api" -P -F '#{pane_id}')
tmux select-layout -t "$W_hw_api" tiled
tmux send-keys -t "$P" "$SETUP; "'waitForTime; export UAV_NAME=uav4; roslaunch pairs_multirotor_simulator hw_api.launch custom_config:=./config/hw_api.yaml nodelet_manager_name:=$UAV_NAME\_nodelet_manager' Enter
P=$(tmux split-window -t "$W_hw_api" -P -F '#{pane_id}')
tmux select-layout -t "$W_hw_api" tiled
tmux send-keys -t "$P" "$SETUP; "'waitForTime; export UAV_NAME=uav5; roslaunch pairs_multirotor_simulator hw_api.launch custom_config:=./config/hw_api.yaml nodelet_manager_name:=$UAV_NAME\_nodelet_manager' Enter
P=$(tmux split-window -t "$W_hw_api" -P -F '#{pane_id}')
tmux select-layout -t "$W_hw_api" tiled
tmux send-keys -t "$P" "$SETUP; "'waitForTime; export UAV_NAME=uav6; roslaunch pairs_multirotor_simulator hw_api.launch custom_config:=./config/hw_api.yaml nodelet_manager_name:=$UAV_NAME\_nodelet_manager' Enter
P=$(tmux split-window -t "$W_hw_api" -P -F '#{pane_id}')
tmux select-layout -t "$W_hw_api" tiled
tmux send-keys -t "$P" "$SETUP; "'waitForTime; export UAV_NAME=uav7; roslaunch pairs_multirotor_simulator hw_api.launch custom_config:=./config/hw_api.yaml nodelet_manager_name:=$UAV_NAME\_nodelet_manager' Enter
P=$(tmux split-window -t "$W_hw_api" -P -F '#{pane_id}')
tmux select-layout -t "$W_hw_api" tiled
tmux send-keys -t "$P" "$SETUP; "'waitForTime; export UAV_NAME=uav8; roslaunch pairs_multirotor_simulator hw_api.launch custom_config:=./config/hw_api.yaml nodelet_manager_name:=$UAV_NAME\_nodelet_manager' Enter
P=$(tmux split-window -t "$W_hw_api" -P -F '#{pane_id}')
tmux select-layout -t "$W_hw_api" tiled
tmux send-keys -t "$P" "$SETUP; "'waitForTime; export UAV_NAME=uav9; roslaunch pairs_multirotor_simulator hw_api.launch custom_config:=./config/hw_api.yaml nodelet_manager_name:=$UAV_NAME\_nodelet_manager' Enter
P=$(tmux split-window -t "$W_hw_api" -P -F '#{pane_id}')
tmux select-layout -t "$W_hw_api" tiled
tmux send-keys -t "$P" "$SETUP; "'waitForTime; export UAV_NAME=uav10; roslaunch pairs_multirotor_simulator hw_api.launch custom_config:=./config/hw_api.yaml nodelet_manager_name:=$UAV_NAME\_nodelet_manager' Enter
tmux select-layout -t "$W_hw_api" tiled

# ---------------- window: control ----------------
read W_control P <<< "$(tmux new-window -t "$SESSION_NAME" -n "control" -P -F '#{window_id} #{pane_id}')"
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav1; waitForTime; roslaunch pairs_uav_core core.launch' Enter
P=$(tmux split-window -t "$W_control" -P -F '#{pane_id}')
tmux select-layout -t "$W_control" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav2; waitForTime; roslaunch pairs_uav_core core.launch' Enter
P=$(tmux split-window -t "$W_control" -P -F '#{pane_id}')
tmux select-layout -t "$W_control" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav3; waitForTime; roslaunch pairs_uav_core core.launch' Enter
P=$(tmux split-window -t "$W_control" -P -F '#{pane_id}')
tmux select-layout -t "$W_control" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav4; waitForTime; roslaunch pairs_uav_core core.launch' Enter
P=$(tmux split-window -t "$W_control" -P -F '#{pane_id}')
tmux select-layout -t "$W_control" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav5; waitForTime; roslaunch pairs_uav_core core.launch' Enter
P=$(tmux split-window -t "$W_control" -P -F '#{pane_id}')
tmux select-layout -t "$W_control" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav6; waitForTime; roslaunch pairs_uav_core core.launch' Enter
P=$(tmux split-window -t "$W_control" -P -F '#{pane_id}')
tmux select-layout -t "$W_control" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav7; waitForTime; roslaunch pairs_uav_core core.launch' Enter
P=$(tmux split-window -t "$W_control" -P -F '#{pane_id}')
tmux select-layout -t "$W_control" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav8; waitForTime; roslaunch pairs_uav_core core.launch' Enter
P=$(tmux split-window -t "$W_control" -P -F '#{pane_id}')
tmux select-layout -t "$W_control" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav9; waitForTime; roslaunch pairs_uav_core core.launch' Enter
P=$(tmux split-window -t "$W_control" -P -F '#{pane_id}')
tmux select-layout -t "$W_control" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav10; waitForTime; roslaunch pairs_uav_core core.launch' Enter
tmux select-layout -t "$W_control" tiled

# ---------------- window: automatic_start ----------------
read W_automatic_start P <<< "$(tmux new-window -t "$SESSION_NAME" -n "automatic_start" -P -F '#{window_id} #{pane_id}')"
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav1; waitForTime; roslaunch pairs_uav_autostart automatic_start.launch custom_config:=./config/automatic_start.yaml' Enter
P=$(tmux split-window -t "$W_automatic_start" -P -F '#{pane_id}')
tmux select-layout -t "$W_automatic_start" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav2; waitForTime; roslaunch pairs_uav_autostart automatic_start.launch custom_config:=./config/automatic_start.yaml' Enter
P=$(tmux split-window -t "$W_automatic_start" -P -F '#{pane_id}')
tmux select-layout -t "$W_automatic_start" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav3; waitForTime; roslaunch pairs_uav_autostart automatic_start.launch custom_config:=./config/automatic_start.yaml' Enter
P=$(tmux split-window -t "$W_automatic_start" -P -F '#{pane_id}')
tmux select-layout -t "$W_automatic_start" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav4; waitForTime; roslaunch pairs_uav_autostart automatic_start.launch custom_config:=./config/automatic_start.yaml' Enter
P=$(tmux split-window -t "$W_automatic_start" -P -F '#{pane_id}')
tmux select-layout -t "$W_automatic_start" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav5; waitForTime; roslaunch pairs_uav_autostart automatic_start.launch custom_config:=./config/automatic_start.yaml' Enter
P=$(tmux split-window -t "$W_automatic_start" -P -F '#{pane_id}')
tmux select-layout -t "$W_automatic_start" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav6; waitForTime; roslaunch pairs_uav_autostart automatic_start.launch custom_config:=./config/automatic_start.yaml' Enter
P=$(tmux split-window -t "$W_automatic_start" -P -F '#{pane_id}')
tmux select-layout -t "$W_automatic_start" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav7; waitForTime; roslaunch pairs_uav_autostart automatic_start.launch custom_config:=./config/automatic_start.yaml' Enter
P=$(tmux split-window -t "$W_automatic_start" -P -F '#{pane_id}')
tmux select-layout -t "$W_automatic_start" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav8; waitForTime; roslaunch pairs_uav_autostart automatic_start.launch custom_config:=./config/automatic_start.yaml' Enter
P=$(tmux split-window -t "$W_automatic_start" -P -F '#{pane_id}')
tmux select-layout -t "$W_automatic_start" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav9; waitForTime; roslaunch pairs_uav_autostart automatic_start.launch custom_config:=./config/automatic_start.yaml' Enter
P=$(tmux split-window -t "$W_automatic_start" -P -F '#{pane_id}')
tmux select-layout -t "$W_automatic_start" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav10; waitForTime; roslaunch pairs_uav_autostart automatic_start.launch custom_config:=./config/automatic_start.yaml' Enter
tmux select-layout -t "$W_automatic_start" tiled

# ---------------- window: goto ----------------
read W_goto P <<< "$(tmux new-window -t "$SESSION_NAME" -n "goto" -P -F '#{window_id} #{pane_id}')"
tmux send-keys -t "$P" "$SETUP; "'history -s ./goto.py' Enter
tmux select-layout -t "$W_goto" tiled

# ---------------- window: takeoff ----------------
read W_takeoff P <<< "$(tmux new-window -t "$SESSION_NAME" -n "takeoff" -P -F '#{window_id} #{pane_id}')"
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav1; waitForControl; rosservice call /$UAV_NAME/hw_api/arming 1; sleep 2; rosservice call /$UAV_NAME/hw_api/offboard; exit' Enter
P=$(tmux split-window -t "$W_takeoff" -P -F '#{pane_id}')
tmux select-layout -t "$W_takeoff" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav2; waitForControl; rosservice call /$UAV_NAME/hw_api/arming 1; sleep 2; rosservice call /$UAV_NAME/hw_api/offboard; exit' Enter
P=$(tmux split-window -t "$W_takeoff" -P -F '#{pane_id}')
tmux select-layout -t "$W_takeoff" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav3; waitForControl; rosservice call /$UAV_NAME/hw_api/arming 1; sleep 2; rosservice call /$UAV_NAME/hw_api/offboard; exit' Enter
P=$(tmux split-window -t "$W_takeoff" -P -F '#{pane_id}')
tmux select-layout -t "$W_takeoff" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav4; waitForControl; rosservice call /$UAV_NAME/hw_api/arming 1; sleep 2; rosservice call /$UAV_NAME/hw_api/offboard; exit' Enter
P=$(tmux split-window -t "$W_takeoff" -P -F '#{pane_id}')
tmux select-layout -t "$W_takeoff" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav5; waitForControl; rosservice call /$UAV_NAME/hw_api/arming 1; sleep 2; rosservice call /$UAV_NAME/hw_api/offboard; exit' Enter
P=$(tmux split-window -t "$W_takeoff" -P -F '#{pane_id}')
tmux select-layout -t "$W_takeoff" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav6; waitForControl; rosservice call /$UAV_NAME/hw_api/arming 1; sleep 2; rosservice call /$UAV_NAME/hw_api/offboard; exit' Enter
P=$(tmux split-window -t "$W_takeoff" -P -F '#{pane_id}')
tmux select-layout -t "$W_takeoff" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav7; waitForControl; rosservice call /$UAV_NAME/hw_api/arming 1; sleep 2; rosservice call /$UAV_NAME/hw_api/offboard; exit' Enter
P=$(tmux split-window -t "$W_takeoff" -P -F '#{pane_id}')
tmux select-layout -t "$W_takeoff" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav8; waitForControl; rosservice call /$UAV_NAME/hw_api/arming 1; sleep 2; rosservice call /$UAV_NAME/hw_api/offboard; exit' Enter
P=$(tmux split-window -t "$W_takeoff" -P -F '#{pane_id}')
tmux select-layout -t "$W_takeoff" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav9; waitForControl; rosservice call /$UAV_NAME/hw_api/arming 1; sleep 2; rosservice call /$UAV_NAME/hw_api/offboard; exit' Enter
P=$(tmux split-window -t "$W_takeoff" -P -F '#{pane_id}')
tmux select-layout -t "$W_takeoff" tiled
tmux send-keys -t "$P" "$SETUP; "'export UAV_NAME=uav10; waitForControl; rosservice call /$UAV_NAME/hw_api/arming 1; sleep 2; rosservice call /$UAV_NAME/hw_api/offboard; exit' Enter
tmux select-layout -t "$W_takeoff" tiled

# ---------------- window: rviz ----------------
read W_rviz P <<< "$(tmux new-window -t "$SESSION_NAME" -n "rviz" -P -F '#{window_id} #{pane_id}')"
tmux send-keys -t "$P" "$SETUP; "'waitForControl; rosrun rviz rviz -d ./rviz.rviz' Enter
tmux select-layout -t "$W_rviz" tiled

# ---------------- window: layout ----------------
read W_layout P <<< "$(tmux new-window -t "$SESSION_NAME" -n "layout" -P -F '#{window_id} #{pane_id}')"
tmux send-keys -t "$P" "$SETUP; "'waitForControl; sleep 5; ~/.i3/layout_manager.sh ./layout.json' Enter
tmux select-layout -t "$W_layout" tiled

# ---------------- window: kill (press enter inside to stop the session) ----------------
read W_kill P <<< "$(tmux new-window -t "$SESSION_NAME" -n "kill" -P -F '#{window_id} #{pane_id}')"
tmux send-keys -t "$P" "$SCRIPTPATH/kill.sh"

# mouse support (select panes / scroll with the mouse)
tmux set-option -t "$SESSION_NAME" mouse on

tmux select-window -t "$W_goto"
tmux -2 attach-session -t "$SESSION_NAME"
