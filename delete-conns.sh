#!/bin/bash

#
# Copyright 2021 by by 0x7c2, Simon Brecht.
# All rights reserved.
# This file is used to delete specific connections from kernel tables,
# and is released under the "Apache License 2.0". Please see the LICENSE
# file that should have been included as part of this package.
# 

if [ $# -ne 1 ]; then
        echo
        echo Delete all connections from kernel table for
        echo specified ip address.
        echo
        echo "Usage:"
        echo "$0 <ip-addr>"
        echo
        exit
fi
 
IPADDR0=$1
IPADDR1=`echo ${IPADDR0//./ }`
IPADDR2=`printf '%02X' ${IPADDR1}`
 
echo "Deleting Connections for $IPADDR0, HEX: ${IPADDR2} ..."
 
fw tab -t connections -u  | grep -i ${IPADDR2} | while read line
do
        DIR=`echo $line | cut -c9-9`
        SRC=`echo $line | cut -d " " -f 2 | cut -c1-8`
        SPO=`echo $line | cut -d " " -f 3 | cut -c1-8`
        DST=`echo $line | cut -d " " -f 4 | cut -c1-8`
        DPO=`echo $line | cut -d " " -f 5 | cut -c1-8`
        PRO=`echo $line | cut -d " " -f 6 | cut -c1-8`
 
        echo "Deleting Connection: <$DIR><$SRC><$SPO><$DST><$DPO><$PRO>"
        RES=`fw tab -t connections -x -e "$DIR,$SRC,$SPO,$DST,$DPO,$PRO"`
done
