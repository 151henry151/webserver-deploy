#!/bin/bash
# Bring up a bunch of websites at once
#
# Update a bunch of zone records from a 
# domain list using Gandi's LiveDNS
# If using a host that has a dynamic IP address, place 
# this script into a crontab or make it run  when the
# WAN interface comes up.

# Get gandi API key from file
if [ -f ~/.gandi_api.key]; then
  . ~/.gandi_api.key
fi

# Set zone
zone1="ROMPWEB"

# Read file called enable_domains.list and for each domain in the list
# set the IP address to the current IP address of this machine
while IFS= read -r line; do 
    DOMAIN="$line"
    RECORD="$zone1"
    APIKEY="gandi_key"
    
    API="https://dns.api.gandi.net/api/v5/"
    IP_SERVICE="http://me.gandi.net"
    
    IP4=$(curl -s4 $IP_SERVICE)
    IP6=$(curl -s6 $IP_SERVICE)
    
    if [[ -z "$IP4" && -z "$IP6" ]]; then
        echo "Something went wrong. Can not get your IP from $IP_SERVICE "
        exit 1
    fi
    
    
    if [[ ! -z "$IP4" ]]; then
        DATA='{"rrset_values": ["'$IP4'"]}'
        curl -s -XPUT -d "$DATA" \
            -H"X-Api-Key: $APIKEY" \
            -H"Content-Type: application/json" \
            "$API/domains/$DOMAIN/records/$RECORD/A"
    fi
    
    if [[ ! -z "$IP6" ]]; then
        DATA='{"rrset_values": ["'$IP6'"]}'
        curl -s -XPUT -d "$DATA" \
            -H"X-Api-Key: $APIKEY" \
            -H"Content-Type: application/json" \
            "$API/domains/$DOMAIN/records/$RECORD/AAAA"
    fi


done < enable_domains.list
