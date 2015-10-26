# get the IP from eth1 interface
IP=`hostname -I | cut -d ' ' -f 2`

# bootstrap the etcd cluster
etcd -name `hostname` -initial-advertise-peer-urls http://$IP:2380 \
    -listen-peer-urls http://$IP:2380 \
    -listen-client-urls http://$IP:2379,http://127.0.0.1:2379 \
    -advertise-client-urls http://$IP:2379 \
    -initial-cluster-token etcd-cluster-1 \
    -initial-cluster `hostname`=http://$IP:2380 \
    -initial-cluster-state new

# adds new member; if peer is exist, it won't be added
etcdctl member add etcd2 http://172.20.20.11:2380
