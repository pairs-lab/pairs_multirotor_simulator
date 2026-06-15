# pairs_multirotor_simulator

A lightweight, dependency-free multirotor flight simulator for the PAIRS UAV stack. It integrates rigid-body multirotor dynamics with an ODE solver (Boost odeint) and can run many UAVs at once without a heavy 3D engine, making it ideal for fast control/estimation/planning testing. A hardware-API plugin lets the rest of the PAIRS stack drive simulated drones exactly as it would real ones.

## Contents

- **`MultirotorSimulator` composable node** (`pairs_multirotor_simulator::MultirotorSimulator`) — runs the multi-UAV physics and publishes odometry/sensor topics
- **hw_api plugin** (`pairs_uav_simulator_hw_api_plugin::Api`) — a `pairs_uav_hw_api` plugin so the PAIRS control stack talks to the simulator through the standard hardware API
- **Vehicle configs** — ready-to-use parameter sets for `a300`, `f330`, `f450`, `f550`, `t650`, `x500`, and `robofly`, plus cascaded attitude/rate/velocity/position controllers and a mixer
- **tmux sessions** — `standalone`, `pairs_one_drone`, `pairs_two_drones`, `standalone_400_uavs`
- **Launch files** — `multirotor_simulator.launch.py`, `hw_api.launch.py`

## Branches

- `ros1` — ROS 1 Noetic (catkin)
- `ros2` — ROS 2 Jazzy (ament_cmake)

## Install (ROS 2 Jazzy)

```bash
sudo apt install ros-jazzy-pairs-multirotor-simulator
```

## Usage

Launch the simulator directly:

```bash
ros2 launch pairs_multirotor_simulator multirotor_simulator.launch.py
```

Or start a full pre-wired tmux session (simulator + RViz + layout):

```bash
cd tmux/standalone && ./start.sh
```

## License

BSD 3-Clause (© 2020 PAIRS group, CTU Prague; PAIRS adaptations © 2024 Thanh Nguyen Canh). Vendors Boost odeint under the Boost Software License 1.0. See [LICENSE](LICENSE).
