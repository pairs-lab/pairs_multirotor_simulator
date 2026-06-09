#ifndef UAV_SYSTEM_ROS_H
#define UAV_SYSTEM_ROS_H

#include <rclcpp/rclcpp.hpp>

#include <pairs_lib/transform_broadcaster.h>

#include <pairs_lib/param_loader.h>
#include <pairs_lib/publisher_handler.h>
#include <pairs_lib/subscriber_handler.h>
#include <pairs_lib/service_server_handler.h>
#include <pairs_lib/mutex.h>
#include <pairs_lib/attitude_converter.h>

#include <pairs_multirotor_simulator/uav_system/uav_system.hpp>

#include <sensor_msgs/msg/imu.hpp>
#include <sensor_msgs/msg/range.hpp>
#include <nav_msgs/msg/odometry.hpp>
#include <pairs_msgs/msg/float64.hpp>
#include <pairs_msgs/srv/float64_srv.hpp>

#include <pairs_msgs/msg/hw_api_actuator_cmd.hpp>
#include <pairs_msgs/msg/hw_api_control_group_cmd.hpp>
#include <pairs_msgs/msg/hw_api_attitude_rate_cmd.hpp>
#include <pairs_msgs/msg/hw_api_attitude_cmd.hpp>
#include <pairs_msgs/msg/hw_api_acceleration_hdg_rate_cmd.hpp>
#include <pairs_msgs/msg/hw_api_acceleration_hdg_cmd.hpp>
#include <pairs_msgs/msg/hw_api_velocity_hdg_rate_cmd.hpp>
#include <pairs_msgs/msg/hw_api_velocity_hdg_cmd.hpp>
#include <pairs_msgs/msg/hw_api_position_cmd.hpp>
#include <pairs_msgs/msg/tracker_command.hpp>

namespace pairs_multirotor_simulator
{

struct UavSystemRos_CommonHandlers_t
{

  rclcpp::Node::SharedPtr                                       node;
  std::string                                                   uav_name;
  std::optional<std::shared_ptr<pairs_lib::TransformBroadcaster>> transform_broadcaster;
};

class UavSystemRos {

public:
  UavSystemRos(const UavSystemRos_CommonHandlers_t common_handlers);

  void makeStep(const double dt, const double time_stamp);

  void crash(void);

  bool hasCrashed(void);

  void applyForce(const Eigen::Vector3d& force);

  Eigen::Vector3d getPose(void);

  MultirotorModel::ModelParams getParams();
  MultirotorModel::State       getState();

private:
  rclcpp::Node::SharedPtr node_;

  rclcpp::CallbackGroup::SharedPtr cbgrp_subs_;
  rclcpp::CallbackGroup::SharedPtr cbgrp_ss_;

  rclcpp::Time time_stamp_;
  std::mutex   mutex_time_stamp_;

  std::atomic<bool> is_initialized_ = false;
  std::string       _uav_name_;

  double randd(double from, double to);

  bool   _randomization_enabled_;
  double _randomization_bounds_x_;
  double _randomization_bounds_y_;
  double _randomization_bounds_z_;

  // | ------------------------ UavSystem ----------------------- |

  UavSystem::INPUT_MODE last_input_mode_;

  UavSystem  uav_system_;
  std::mutex mutex_uav_system_;

  rclcpp::Time time_last_input_;
  std::mutex   mutex_time_last_input_;

  MultirotorModel::ModelParams model_params_;

  bool   _iterate_without_input_;
  double _input_timeout_;

  std::string _frame_world_;
  std::string _frame_fcu_;
  std::string _frame_rangefinder_;
  bool        _publish_rangefinder_tf_;
  bool        _publish_fcu_tf_;

  // | ----------------------- publishers ----------------------- |

  std::shared_ptr<pairs_lib::PublisherHandler<sensor_msgs::msg::Imu>>   ph_imu_;
  std::shared_ptr<pairs_lib::PublisherHandler<nav_msgs::msg::Odometry>> ph_odom_;
  std::shared_ptr<pairs_lib::PublisherHandler<sensor_msgs::msg::Range>> ph_rangefinder_;

  void publishOdometry(const MultirotorModel::State& state);
  void publishFCUTF(const MultirotorModel::State& state);
  void publishIMU(const MultirotorModel::State& state);
  void publishRangefinder(const MultirotorModel::State& state);

  void timeoutInput(void);

  // | --------------------------- tf --------------------------- |

  std::shared_ptr<pairs_lib::TransformBroadcaster> tf_broadcaster_;

  // | ----------------------- subscribers ---------------------- |

  void callbackActuatorCmd(const pairs_msgs::msg::HwApiActuatorCmd::ConstSharedPtr msg);
  void callbackControlGroupCmd(const pairs_msgs::msg::HwApiControlGroupCmd::ConstSharedPtr msg);
  void callbackAttitudeRateCmd(const pairs_msgs::msg::HwApiAttitudeRateCmd::ConstSharedPtr msg);
  void callbackAttitudeCmd(const pairs_msgs::msg::HwApiAttitudeCmd::ConstSharedPtr msg);
  void callbackAccelerationHdgRateCmd(const pairs_msgs::msg::HwApiAccelerationHdgRateCmd::ConstSharedPtr msg);
  void callbackAccelerationHdgCmd(const pairs_msgs::msg::HwApiAccelerationHdgCmd::ConstSharedPtr msg);
  void callbackVelocityHdgRateCmd(const pairs_msgs::msg::HwApiVelocityHdgRateCmd::ConstSharedPtr msg);
  void callbackVelocityHdgCmd(const pairs_msgs::msg::HwApiVelocityHdgCmd::ConstSharedPtr msg);
  void callbackPositionCmd(const pairs_msgs::msg::HwApiPositionCmd::ConstSharedPtr msg);
  void callbackTrackerCmd(const pairs_msgs::msg::TrackerCommand::ConstSharedPtr msg);

  rclcpp::Subscription<pairs_msgs::msg::HwApiPositionCmd>::SharedPtr sub_pos_cmd_;

  pairs_lib::SubscriberHandler<pairs_msgs::msg::HwApiActuatorCmd>            sh_actuator_cmd_;
  pairs_lib::SubscriberHandler<pairs_msgs::msg::HwApiControlGroupCmd>        sh_control_group_cmd_;
  pairs_lib::SubscriberHandler<pairs_msgs::msg::HwApiAttitudeRateCmd>        sh_attitude_rate_cmd_;
  pairs_lib::SubscriberHandler<pairs_msgs::msg::HwApiAttitudeCmd>            sh_attitude_cmd_;
  pairs_lib::SubscriberHandler<pairs_msgs::msg::HwApiAccelerationHdgRateCmd> sh_acceleration_hdg_rate_cmd_;
  pairs_lib::SubscriberHandler<pairs_msgs::msg::HwApiAccelerationHdgCmd>     sh_acceleration_hdg_cmd_;
  pairs_lib::SubscriberHandler<pairs_msgs::msg::HwApiVelocityHdgRateCmd>     sh_velocity_hdg_rate_cmd_;
  pairs_lib::SubscriberHandler<pairs_msgs::msg::HwApiVelocityHdgCmd>         sh_velocity_hdg_cmd_;
  pairs_lib::SubscriberHandler<pairs_msgs::msg::HwApiPositionCmd>            sh_position_cmd_;
  pairs_lib::SubscriberHandler<pairs_msgs::msg::TrackerCommand>              sh_tracker_cmd_;

  // | --------------------- service servers -------------------- |

  pairs_lib::ServiceServerHandler<pairs_msgs::srv::Float64Srv> ss_set_mass_;
  pairs_lib::ServiceServerHandler<pairs_msgs::srv::Float64Srv> ss_set_ground_z_;

  bool callbackSetMass(const std::shared_ptr<pairs_msgs::srv::Float64Srv::Request> request, const std::shared_ptr<pairs_msgs::srv::Float64Srv::Response> response);

  bool callbackSetGroundZ(const std::shared_ptr<pairs_msgs::srv::Float64Srv::Request>  request,
                          const std::shared_ptr<pairs_msgs::srv::Float64Srv::Response> response);

  // | ------------------------ routines ------------------------ |

  void calculateInertia(MultirotorModel::ModelParams& params);
};

}  // namespace pairs_multirotor_simulator

#endif  // UAV_SYSTEM_ROS_H
