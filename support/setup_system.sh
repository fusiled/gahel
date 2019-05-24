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

echo "export GAELHOME=/gael"   >> /home/$USERNAME/.bashrc
echo 'export PATH=$GAELHOME/bin:$PATH'   >> /home/$USERNAME/.bashrc

cd /gael
su $USERNAME
