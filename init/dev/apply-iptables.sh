#!/bin/bash
basic=/opt/iptables/iptables.rules
other=/opt/iptables/other.rules
end=/opt/iptables/end.rules
all=/opt/iptables/all.rules

cat $basic >$all
cat $other >>$all
/opt/iptables/ss-libev-rules>>$all
cat $end >>$all

/sbin/iptables-restore $all
