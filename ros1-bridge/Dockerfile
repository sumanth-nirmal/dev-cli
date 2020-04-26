FROM osrf/ros:dashing-ros1-bridge
VOLUME /opt/ros1-bridge
CMD ["/bin/sh", "-c", "trap 'exit 147' TERM; tail -f /dev/null & wait ${!}"]
