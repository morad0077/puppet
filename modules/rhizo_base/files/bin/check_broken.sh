#!/bin/bash
RHIZO_SCRIPT="/home/rhizomatica/bin"
. $RHIZO_SCRIPT/vars.sh
. /etc/profile.d/rccn-functions.sh

NACK=`echo "show lchan" | nc -q1 localhost 4242 | grep "BROKEN UNUSABLE Error reason: NACK on activation" | wc -l`

if [ $NACK -gt 0 ]; then
	waitfor0calls
	_bts=0
	for bts in "${BTS[@]}" ; do
	  echo "Dropping BTS connection $_bts due to $NACK broken (NACK) Channels"
	  echo -e "enable\n drop bts connection $_bts oml" | nc -q1 localhost 4242
	done
	((_bts+=2))
fi
