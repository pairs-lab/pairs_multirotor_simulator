cmake_minimum_required(VERSION 3.5)
project(pairs_multirotor_simulator)

# set the correct standards
set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# set the compile options to show code warnings
if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra)
endif()

# 1 == use rclcpp::Timer implementation
# 0 == use PAIRS's thread timer implementation
set(USE_ROS_TIMER 0)

if(${USE_ROS_TIMER})
  MESSAGE(WARNING "[pairs_uav_managers]: Compiling with ROS Timers. This can cause high CPU load in runtime.")
endif()

if(ENABLE_COVERAGE)
  message(WARNING "building for coverage, the performance might be limited")

  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --coverage -fprofile-arcs")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage -fprofile-arcs")

  add_definitions("-O1")
  add_definitions("-g")
endif()

set(DEPENDENCIES
  rclcpp
  rclcpp_components
  pairs_msgs
  pairs_lib
  pluginlib
  geometry_msgs
  nav_msgs
  std_msgs
  sensor_msgs
  pairs_uav_hw_api
  Eigen3
  backward_ros
)

set(LIBRARIES
  PairsMultirotorSimulator_Simulator
  PairsMultirotorSimulator_SimulatorSystemRos
  PairsMultirotorSimulator_HwApiPlugin
  )

foreach(DEP IN LISTS DEPENDENCIES)
  find_package(${DEP} REQUIRED)
endforeach()

include_directories(
  include
  include/pairs_multirotor_simulator
  include/pairs_multirotor_simulator/uav_system
  include/pairs_multirotor_simulator/uav_system/controllers
  ${rclcpp_INCLUDE_DIRS}
  ${pairs_lib_INCLUDE_DIRS}
  ${pairs_uav_hw_api_INCLUDE_DIRS}
)

# ROS Wrapper for the Multirotor UAV System + controllers

add_library(PairsMultirotorSimulator_SimulatorSystemRos SHARED
  src/uav_system_ros.cpp
)

ament_target_dependencies(PairsMultirotorSimulator_SimulatorSystemRos
  ${DEPENDENCIES}
)

# PAIRS Simulator

add_library(PairsMultirotorSimulator_Simulator SHARED
  src/multirotor_simulator.cpp
)

target_link_libraries(PairsMultirotorSimulator_Simulator
  PairsMultirotorSimulator_SimulatorSystemRos
  )

ament_target_dependencies(PairsMultirotorSimulator_Simulator
  ${DEPENDENCIES}
)

rclcpp_components_register_nodes(PairsMultirotorSimulator_Simulator PLUGIN "pairs_multirotor_simulator::MultirotorSimulator" EXECUTABLE PairsMultirotorSimulator_Simulator)

# HW Api Plugin

add_library(PairsMultirotorSimulator_HwApiPlugin SHARED
  src/hw_api_plugin.cpp
)

ament_target_dependencies(PairsMultirotorSimulator_HwApiPlugin
  ${DEPENDENCIES}
)

target_compile_definitions(PairsMultirotorSimulator_HwApiPlugin PRIVATE USE_ROS_TIMER=${USE_ROS_TIMER})

## --------------------------------------------------------------
## |                       Export plugins                       |
## --------------------------------------------------------------

# <package of the base class>, <relative path to the xml>
pluginlib_export_plugin_description_file(pairs_uav_hw_api plugins.xml)

## --------------------------------------------------------------
## |                           install                          |
## --------------------------------------------------------------

ament_export_libraries(
  ${LIBRARIES}
)

install(
  TARGETS ${LIBRARIES}
  EXPORT export_${PROJECT_NAME}
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
)

install(
  DIRECTORY include
  DESTINATION .
)

install(
  DIRECTORY launch
  DESTINATION share/${PROJECT_NAME}
)

install(
  DIRECTORY config
  DESTINATION share/${PROJECT_NAME}
)

install(
  DIRECTORY tmux
  USE_SOURCE_PERMISSIONS
  DESTINATION share/${PROJECT_NAME}
)

install(
  DIRECTORY scripts
  USE_SOURCE_PERMISSIONS
  DESTINATION lib/${PROJECT_NAME}
)

ament_export_include_directories(
  include
)

ament_export_targets(
  export_${PROJECT_NAME} HAS_LIBRARY_TARGET
)

ament_export_dependencies(
  ${DEPENDENCIES}
)

ament_package()
