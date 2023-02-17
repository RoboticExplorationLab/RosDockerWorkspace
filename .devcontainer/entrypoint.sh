#!/bin/bash
export DISPLAY=:20
Xvfb :20 -screen 0 1366x768x16 &
x11vnc -passwd 1234 -display :20 -N -forever -create &
# x11vnc -forever -usepw -create & 
/bin/bash