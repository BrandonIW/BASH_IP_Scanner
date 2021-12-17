#!/bin/bash
#===============================================================================
#
#          FILE:  NetworkScanner.sh
# 
#         USAGE:  ./NetworkScanner.sh 
# 
#   DESCRIPTION:  Network Scanner Tool
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Brandon Wittet (), Brandon.wittet@gmail.com
#       COMPANY:  Open Source
#       VERSION:  1.0
#       CREATED:  2021-12-17 01:40:38 PM PST
#      REVISION:  ---
#===============================================================================


ipaddr=$(ip -a addr | egrep inet\\s\(192\|172\|10\) | cut -d " " -f 6 | cut -d "." -f 1,2,3)

function check_alive () {
	alive=$(echo "${1}" | egrep [0-9]\\sreceived | cut -d " " -f 4)
	if [[ $alive == 1 ]]; then
		return 0
	fi

	return 1
}

function pinger () {
	for host_addr in {1..255}; do
		host="${ipaddr}"."${host_addr}"
		echo -n Scanning target "${host}"; sleep 1; echo -n .; sleep 1; echo -n .; sleep 1; echo -n .
		response=$(ping -c 1 "${host}")
	
		check_alive "${response}"
		
		if [[ $? == 0 ]]; then
			echo "${host}" is alive >> "${ipaddr}"_Scan.txt
		else
			echo "${host}" is dead >> "${ipaddr}"_Scan.txt
		fi
	done
}

pinger

