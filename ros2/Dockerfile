FROM osrf/ros:dashing-desktop
VOLUME /opt/ros2
CMD ["/bin/sh", "-c", "trap 'exit 147' TERM; tail -f /dev/null & wait ${!}"]
