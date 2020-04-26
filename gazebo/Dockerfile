FROM gazebo:libgazebo11
VOLUME /opt/gazebo
CMD ["/bin/sh", "-c", "trap 'exit 147' TERM; tail -f /dev/null & wait ${!}"]
