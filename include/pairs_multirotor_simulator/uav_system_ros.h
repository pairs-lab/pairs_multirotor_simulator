#ifndef UAV_SYSTEM_ROS_H
#define UAV_SYSTEM_ROS_H

#include <ros/ros.h>
#include <nodelet/nodelet.h>

#include <pairs_lib/transform_broadcaster.h>

#include <pairs_lib/param_loader.h>
#include <pairs_lib/publisher_handler.h>
#include <pairs_lib/subscribe_handler.h>
#include <pairs_lib/mutex.h>
#include <pairs_lib/attitude_converter.h>

#include <pairs_multirotor_simulator/uav_system/uav_system.hpp>

#include <sensor_msgs/Imu.h>
#include <sensor_msgs/Range.h>
#include <nav_msgs/Odometry.h>
#include <pairs_msgs/Float64Srv.h>

#include <pairs_msgs/HwApiActuatorCmd.h>
#include <pairs_msgs/HwApiControlGroupCmd.h>
#include <pairs_msgs/HwApiAttitudeRateCmd.h>
#include <pairs_msgs/HwApiAttitudeCmd.h>
#include <pairs_msgs/HwApiAccelerationHdgRateCmd.h>
#include <pairs_msgs/HwApiAccelerationHdgCmd.h>
#include <pairs_msgs/HwApiVelocityHdgRateCmd.h>
#include <pairs_msgs/HwApiVelocityHdgCmd.h>
#include <pairs_msgs/HwApiPositionCmd.h>
#include <pairs_msgs/TrackerCommand.h>

namespace pairs_multirotor_simulator
{

class UavSystemRos {

public:
  UavSystemRos(ros::NodeHandle& nh, const std::string name);

  void makeStep(const double dt);

  void crash(void);

  bool hasCrashed(void);

  void applyForce(const Eigen::Vector3d& force);

  Eigen::Vector3d getPose(void);

  MultirotorModel::ModelParams getParams();
  MultirotorModel::State       getState();

private:
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

  ros::Time  time_last_input_;
  std::mutex mutex_time_last_input_;

  MultirotorModel::ModelParams model_params_;

  bool   _iterate_without_input_;
  double _input_timeout_;

  std::string _frame_world_;
  std::string _frame_fcu_;
  std::string _frame_rangefinder_;
  bool        _publish_rangefinder_tf_;
  bool        _publish_fcu_tf_;

  // | ----------------------- publishers ----------------------- |

  pairs_lib::PublisherHandler<sensor_msgs::Imu>   ph_imu_;
  pairs_lib::PublisherHandler<nav_msgs::Odometry> ph_odom_;
  pairs_lib::PublisherHandler<sensor_msgs::Range> ph_rangefinder_;

  void publishOdometry(const MultirotorModel::State& state);
  void publishIMU(const MultirotorModel::State& state);
  void publishRangefinder(const MultirotorModel::State& state);

  void timeoutInput(void);

  // | --------------------------- tf --------------------------- |

  std::shared_ptr<pairs_lib::TransformBroadcaster> tf_broadcaster_;

  // | ----------------------- subscribers ---------------------- |

  void callbackActuatorCmd(const pairs_msgs::HwApiActuatorCmd::ConstPtr msg);
  void callbackControlGroupCmd(const pairs_msgs::HwApiControlGroupCmd::ConstPtr msg);
  void callbackAttitudeRateCmd(const pairs_msgs::HwApiAttitudeRateCmd::ConstPtr msg);
  void callbackAttitudeCmd(const pairs_msgs::HwApiAttitudeCmd::ConstPtr msg);
  void callbackAccelerationHdgRateCmd(const pairs_msgs::HwApiAccelerationHdgRateCmd::ConstPtr msg);
  void callbackAccelerationHdgCmd(const pairs_msgs::HwApiAccelerationHdgCmd::ConstPtr msg);
  void callbackVelocityHdgRateCmd(const pairs_msgs::HwApiVelocityHdgRateCmd::ConstPtr msg);
  void callbackVelocityHdgCmd(const pairs_msgs::HwApiVelocityHdgCmd::ConstPtr msg);
  void callbackPositionCmd(const pairs_msgs::HwApiPositionCmd::ConstPtr msg);
  void callbackTrackerCmd(const pairs_msgs::TrackerCommand::ConstPtr msg);

  pairs_lib::SubscribeHandler<pairs_msgs::HwApiActuatorCmd>            sh_actuator_cmd_;
  pairs_lib::SubscribeHandler<pairs_msgs::HwApiControlGroupCmd>        sh_control_group_cmd_;
  pairs_lib::SubscribeHandler<pairs_msgs::HwApiAttitudeRateCmd>        sh_attitude_rate_cmd_;
  pairs_lib::SubscribeHandler<pairs_msgs::HwApiAttitudeCmd>            sh_attitude_cmd_;
  pairs_lib::SubscribeHandler<pairs_msgs::HwApiAccelerationHdgRateCmd> sh_acceleration_hdg_rate_cmd_;
  pairs_lib::SubscribeHandler<pairs_msgs::HwApiAccelerationHdgCmd>     sh_acceleration_hdg_cmd_;
  pairs_lib::SubscribeHandler<pairs_msgs::HwApiVelocityHdgRateCmd>     sh_velocity_hdg_rate_cmd_;
  pairs_lib::SubscribeHandler<pairs_msgs::HwApiVelocityHdgCmd>         sh_velocity_hdg_cmd_;
  pairs_lib::SubscribeHandler<pairs_msgs::HwApiPositionCmd>            sh_position_cmd_;
  pairs_lib::SubscribeHandler<pairs_msgs::TrackerCommand>              sh_tracker_cmd_;

  // | --------------------- service servers -------------------- |

  ros::ServiceServer service_server_set_mass_;

  ros::ServiceServer service_server_set_ground_z_;

  bool callbackSetMass(pairs_msgs::Float64Srv::Request& req, pairs_msgs::Float64Srv::Response& res);

  bool callbackSetGroundZ(pairs_msgs::Float64Srv::Request& req, pairs_msgs::Float64Srv::Response& res);

  // | ------------------------ routines ------------------------ |

  void calculateInertia(MultirotorModel::ModelParams& params);
};

}  // namespace pairs_multirotor_simulator

#endif  // UAV_SYSTEM_ROS_H
