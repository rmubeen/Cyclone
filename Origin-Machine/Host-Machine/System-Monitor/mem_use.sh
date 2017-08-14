free -m | grep Mem | perl -nle 'BEGIN {$|++} print scalar(localtime), " ", $_' >> mem_use.txt;
free -m | grep Swap | perl -nle 'BEGIN {$|++} print scalar(localtime), " ", $_' >> swap_use.txt;

sleep 0.5

sudo bash mem_use.sh
