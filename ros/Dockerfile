FROM osrf/ros:melodic-desktop-full
VOLUME /opt/ros
CMD ["/bin/sh", "-c", "trap 'exit 147' TERM; tail -f /dev/null & wait ${!}"]
