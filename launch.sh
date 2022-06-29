#!/bin/sh

XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ]
    then
        sudo echo $xauth_list | sudo xauth -f $XAUTH nmerge -
    else
        sudo touch $XAUTH
    fi
    sudo chmod a+r $XAUTH
fi

sudo docker run -it \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
    --runtime=nvidia \
    --privileged \
    --network host \
    --name docker_test_hopper \
    vsc-rosdockerworkspace-dcf37bb33dbdae66f94946832de3379e-uid
