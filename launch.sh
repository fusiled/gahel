set -x
IMAGENAME="gahel:v0"
CONTAINERNAME="gahel_${USER}"
if [ ! "$(docker images -q $IMAGENAME)" ]; then
    echo "[a] Building image $IMAGENAME"
    docker build -t $IMAGENAME .
fi
if [ ! "$(docker ps -a -q -f name=$CONTAINERNAME)" ]; then
    echo "[b1] Creating container $CONTAINERNAME"
    docker run --cap-add=SYS_PTRACE  \
        -it -d -v $PWD:/gahel  --name $CONTAINERNAME \
        $IMAGENAME  /bin/bash /gahel/support/setup_system.sh $USER $(id -u ${USER}) $(id -gn $USER)  $(id -g ${USER})
else
    if [ ! "$(docker ps -q -f name=$CONTAINERNAME)" ]; then
        echo "[b2] Restarting existing container named $CONTAINERNAME"
        docker restart $CONTAINERNAME
    fi
fi

echo "[b2] Restarting existing container named $CONTAINERNAME"
docker exec -it $CONTAINERNAME bash
