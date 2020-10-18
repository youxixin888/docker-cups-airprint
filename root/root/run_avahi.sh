#!/bin/sh
set -e
set -x
if [ -z $NOAVAHI ];then
  rm -rf /etc/avahi/services
  ln -s /services /etc/avahi
  mkdir -p /var/run/dbus/
  dbus-daemon --system
  avahi-daemon
fi
