sudo apt-get install haproxy -y


cat <<EOF >> /etc/haproxy/haproxy.cfg
frontend fe-apiserver
   bind 0.0.0.0:6443
   mode tcp
   option tcplog
   default_backend be-apiserver
backend be-apiserver
   mode tcp
   option tcplog
   option tcp-check
   balance roundrobin
   default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100

       server master1 $master1:6443 check
       server master2 $master2:6443 check
EOF

#restart and verify haproxy

systemctl restart haproxy
systemctl status haproxy
