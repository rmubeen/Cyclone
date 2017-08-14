ifstat -i eth0,ib0 -b | perl -nle 'BEGIN {$|++} print scalar(localtime), " ", $_' >> net_use.txt;
