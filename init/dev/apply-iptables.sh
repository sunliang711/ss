#!/bin/bash
basic=/opt/iptables/iptables.rules
other=/opt/iptables/other.rules
end=/opt/iptables/end.rules

cat $basic $other $end | /sbin/iptables-restore
