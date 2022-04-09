
#speedtest örneği


/queue tree
add limit-at=100M max-limit=100M name=SPEEDTEST parent=global priority=1 queue=default
add limit-at=100M max-limit=100M name="1.SpeedTest UP" packet-mark=speedtest_pkt-up parent=SPEEDTEST priority=1 queue=default
add limit-at=100M max-limit=100M name="2.SpeedTest DOWN" packet-mark=speedtest_pkt-down parent=SPEEDTEST priority=1 queue=default

/ip firewall layer7-protocol
add name=speedtest regexp="^.+(speedtest).*\$"

/ip firewall mangle
add action=mark-connection chain=prerouting layer7-protocol=speedtest new-connection-mark=speedtest_conn
add action=mark-connection chain=prerouting dst-port=8080 new-connection-mark=speedtest_conn protocol=tcp
add action=mark-connection chain=postrouting new-connection-mark=speedtest_conn protocol=tcp src-port=8080
add action=mark-packet chain=prerouting connection-mark=speedtest_conn new-packet-mark=speedtest_pkt-up passthrough=no src-address=192.168.X.0/24
add action=mark-packet chain=prerouting connection-mark=speedtest_conn dst-address=192.168.1.0/24 new-packet-mark=speedtest_pkt-down passthrough=no
add action=mark-packet chain=postrouting connection-mark=speedtest_conn new-packet-mark=speedtest_pkt-up passthrough=no src-address=192.168.X.0/24
add action=mark-packet chain=postrouting connection-mark=speedtest_conn dst-address=192.168.1.0/24 new-packet-mark=speedtest_pkt-down passthrough=no
