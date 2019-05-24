set -x
IMAGENAME="gael:v0"
CONTAINERNAME="gael_${USER}"
if [ ! "$(docker images -q $IMAGENAME)" ]; then
    echo "[a] Building image $IMAGENAME"
    docker build -t $IMAGENAME .
fi
if [ ! "$(docker ps -a -q -f name=$CONTAINERNAME)" ]; then
    echo "[b1] Creating container $CONTAINERNAME"
    docker run \
        -it -v $PWD:/gael  --name $CONTAINERNAME \
        $IMAGENAME  /bin/bash /gael/support/setup_system.sh $USER $(id -u ${USER}) $(id -gn $USER)  $(id -g ${USER})
else
        echo "[b2] Restarting existing container named $CONTAINERNAME"
        docker restart $CONTAINERNAME
        docker attach $CONTAINERNAME
fi

