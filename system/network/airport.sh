lastTxRate=`airport -I | awk '/lastTxRate/ {print $2}'`
SSID=`airport -I | awk '/^\ *SSID/ {print $2}'`
channel=`airport -I | awk '/channel/ {print $2}'`
echo "SSID: $SSID Channel: $channel TxRate: $lastTxRate"
