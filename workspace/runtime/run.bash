#!/bin/bash

#export DELTA_MSEC=20
#export MAX_DELAY_MSEC=100
#export GRPC_PORT=50051
#export UDP_SRV_PORT=54001
#export UDP_SND_PORT=54002
#export CORE_IPADDR=172.30.224.33
ASSET_DEF=asset_def.txt
grep mqtt ${ASSET_DEF} > /dev/null
HAS_MQTT=$?
echo "ASSET_DEF=${ASSET_DEF}"
if [ ${HAS_MQTT} -eq 0 ]
then
    echo "INFO: ACTIVATING MOSQUITTO"
    mosquitto -c ./config/mosquitto.conf &
    MQTT_PORT=1883
    sleep 2
else
    MQTT_PORT=
fi


echo "INFO: ACTIVATING HAKO-CONDUCTOR"
hako-master ${DELTA_MSEC} ${MAX_DELAY_MSEC} ${CORE_IPADDR}:${GRPC_PORT} ${UDP_SRV_PORT} ${UDP_SND_PORT} ${MQTT_PORT} & > /dev/null 

sleep 1

LAST_PID=
for entry in `cat ${ASSET_DEF}`
do
    PROG=`echo $entry | awk -F: '{print $1}'`
    echo "${PROG}" | grep "^#"
    if [ $? -ne 0 ]
    then
        echo "INFO: ACTIVATING $entry"
        bash $PROG &
        LAST_PID=$!
    fi
    sleep 1
done

while [ 1 ]
do
    sleep 10
done
