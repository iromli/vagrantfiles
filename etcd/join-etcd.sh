# this script must be running after etcd1 machine
# already running and etcd cluster is available

# get the IP from eth1 interface
IP=`hostname -I | cut -d ' ' -f 2`

# envvars taken from 'etcdctl member add' command executed at
# etcd1 machine
ETCD_NAME="etcd2"
ETCD_INITIAL_CLUSTER="etcd2=http://$IP:2380,etcd1=http://172.20.20.10:2380"
ETCD_INITIAL_CLUSTER_STATE="existing"

etcd -name $ETCD_NAME \
    -initial-advertise-peer-urls http://$IP:2380 \
    -listen-peer-urls http://$IP:2380 \
    -listen-client-urls http://$IP:2379,http://127.0.0.1:2379 \
    -advertise-client-urls http://$IP:2379 \
    -initial-cluster $ETCD_INITIAL_CLUSTER \
    -initial-cluster-state $ETCD_INITIAL_CLUSTER_STATE
