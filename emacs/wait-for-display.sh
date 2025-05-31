#!/usr/bin/env bash

for i in $(seq 1 20); do
  [ -e /tmp/.X11-unix/X0 ] && exit 0
  [ -n "$XDG_RUNTIME_DIR" ] && [ -e "$XDG_RUNTIME_DIR/wayland-0" ] && exit 0
  sleep 1
done
echo "Neither X11 nor Wayland display socket available after 20s" >&2
exit 1
