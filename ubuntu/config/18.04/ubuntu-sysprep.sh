#!/bin/sh

apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade

sudo apt -y install apt-transport-https ca-certificates curl software-properties-common

## remove packages we do not need
apt-get -y purge --auto-remove ufw

# SYSTEM FIXES
# disable NMI (non maskable interrupt) watchdog
# sudo sh -c "echo 'kernel.nmi_watchdog=0' >> /etc/sysctl.conf"

## SECURITY

# clear the logs
find /var/log -type f -delete

# clean apt
apt-get clean all
dpkg --list
echo "total system packages: $(dpkg --list | wc -l)"


# disable IPv6; alas not yet supported for Cloudstack instances
echo net.ipv6.conf.all.disable_ipv6=1 > /etc/sysctl.d/disableipv6.conf

# delete the random seed
rm -f /var/lib/systemd/random-seed

#ensure cloud-init generator is started
#cat << "EOF" > /etc/cloud/ds-identify.cfg
#policy: enabled
#EOF


## PERFORMANCE

# make kernel cmd line more vm friendly; noop scheduler is for more throughput, deadline for less latency https://access.redhat.com/solutions/5427
sed -i s/'GRUB_CMDLINE_LINUX_DEFAULT=".*"'/'GRUB_CMDLINE_LINUX_DEFAULT="gfxpayload=text elevator=deadline biosdevname=0 net.ifnames=0"'/g /etc/default/grub
update-grub

# implementing some low level settings ad-labam, on CentOS tuned takes care of this - and more
echo kernel.sched_min_granularity_ns=10000000 >> /etc/sysctl.d/tuned.conf
echo kernel.sched_wakeup_granularity_ns=15000000 >> /etc/sysctl.d/tuned.conf
echo vm.dirty_ratio=40 >> /etc/sysctl.d/tuned.conf
echo vm.swappiness=30 >> /etc/sysctl.d/tuned.conf


# OTHER

# delete the udev rules for network devices
# find /etc/udev/rules.d/ -name "*persistent*" -delete

# prepare cloud-init boot scripts
mkdir -p /var/lib/cloud/scripts/per-boot/
mkdir -p /usr/share/cloudstack/

# lock root account
usermod --lock root
