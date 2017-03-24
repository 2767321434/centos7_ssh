#!/bin/bash

PASS=${ROOT_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${ROOT_PASS} ] && echo "preset" || echo "random" )
echo "=> Setting a ${_word} password to the root user"
echo "root:$PASS" | chpasswd
_sspw=${SS_PASS}
if [ -z "$_sspw" ]; then 
   _sspw="123456" 
fi
echo $_sspw |./root/shadowsocks-go.sh 2>&1 | tee shadowsocks-go.log
echo "=> Done!"

echo "========================================================================"
echo "You can now connect to this container via SSH using:"
echo ""
echo "    ssh -p <port> root@<host>"
echo "and enter the root password '$PASS' when prompted"
echo "ss password is '$_sspw'"
echo "Please remember to change the above password as soon as possible!"
echo "========================================================================"

nohup /usr/sbin/sshd -D &
