#!/bin/bash
#Setup environment variables

USERNAME="$1"
USERID="$2"
GROUP="$3"
GROUPID="$4"


#Setting up the user
mkdir /home/$USERNAME
cp -r /etc/skel/.* /home/$USERNAME/
sh -c "echo \"$GROUP:x:$USERID\" >> /etc/group"
sh -c "echo \"$USERNAME:x:$USERID:$GROUPID::/home/$USERNAME:/bin/bash\" >> /etc/passwd"

echo "export GAHELHOME=/gahel"   >> /home/$USERNAME/.bashrc
echo 'export PATH=$GAHELHOME/bin:$PATH'   >> /home/$USERNAME/.bashrc
echo 'export LD_LIBRARY_PATH=$GAHELHOME/lib:$LD_LIBRARY_PATH'   >> /home/$USERNAME/.bashrc

cd /gahel
su $USERNAME
