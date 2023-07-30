#!/bin/bash

cp config/hakoniwa_path.json hakoniwa-unity-tb3model/plugin/plugin-srcs/hakoniwa_path.json 
cp -rp workspace/dev/tb3 hakoniwa-ros2pdu/workspace/src/
mv hakoniwa-ros2pdu/workspace/src/tb3/build-tb3.bash hakoniwa-ros2pdu/workspace/