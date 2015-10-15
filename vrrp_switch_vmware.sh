#!/bin/sh

state=$1
vrid=$2
ifname=$3
priority=$4
adv_int=$5
naddr=$6
family=$7
ips=$8

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
            ip -$family addr add $ip dev $ifname 
            sysctl -w net/ipv6/conf/$ifname/autoconf=0
            sysctl -w net/ipv6/conf/$ifname/accept_ra=0
            sysctl -w net/ipv6/conf/$ifname/forwarding=1
        done
        
        IFS=$OIFS

        ;;

    "backup" )
        # set virtual ips addresses
        OIFS=$IFS
        IFS=','

        for ip in $ips; do
            ip -$family addr del $ip dev $ifname
        done
        
        IFS=$OIFS
        ;;
esac

exit 0
