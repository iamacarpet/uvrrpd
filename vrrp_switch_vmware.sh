#!/bin/sh

state=$1
vrid=$2
ifname=$3
priority=$4
adv_int=$5
naddr=$6
family=$7
ips=$8

# contains(string, substring)
#
# Returns 0 if the specified string contains the specified substring,
# otherwise returns 1.
contains() {
    string="$1"
    substring="$2"
    if test "${string#*$substring}" != "$string"
    then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}

echo "state\t\t$state
vrid\t\t$vrid
ifname\t\t$ifname
priority\t$priority
adv_int\t\t$adv_int
naddr\t\t$naddr
ips\t\t$ips" > /tmp/state.vrrp_${vrid}_${ifname}

echo $ips

case "$state" in 

    "init" )
        # adjust sysctl
        sysctl -w net.ipv4.conf.all.rp_filter=0
        sysctl -w net.ipv4.conf.all.arp_ignore=1
        sysctl -w net.ipv4.conf.all.arp_announce=2

        ;;

    "master" )
        # set virtual ips addresses
        OIFS=$IFS
        IFS=','

        for ip in $ips; do
            if contains ${ip} "|"; then
                interface=$(echo ${ip} | cut -d"|" -f1)
                ipaddress=$(echo ${ip} | cut -d"|" -f2)
                
                ip -$family addr add $ipaddress dev $interface 
                sysctl -w net/ipv6/conf/$interface/autoconf=0
                sysctl -w net/ipv6/conf/$interface/accept_ra=0
                sysctl -w net/ipv6/conf/$interface/forwarding=1
            else
                ip -$family addr add $ip dev $ifname 
                sysctl -w net/ipv6/conf/$ifname/autoconf=0
                sysctl -w net/ipv6/conf/$ifname/accept_ra=0
                sysctl -w net/ipv6/conf/$ifname/forwarding=1
            fi;
        done
        
        IFS=$OIFS

        ;;

    "backup" )
        # set virtual ips addresses
        OIFS=$IFS
        IFS=','

        for ip in $ips; do
            if contains ${ip} "|"; then
                interface=$(echo ${ip} | cut -d"|" -f1)
                ipaddress=$(echo ${ip} | cut -d"|" -f2)
                
                ip -$family addr del $ipaddress dev $interface
            else
                ip -$family addr del $ip dev $ifname
            fi;
        done
        
        IFS=$OIFS
        ;;
esac

exit 0
