apt-get install python-pip

pip install shadowsocks


cat >/etc/shadowsocks.json <<END
{
    "server": "0.0.0.0",
    "port_password": {
        "443" : "mrcd@123"
    },
    "timeout":300,
    "method":"chacha20",
    "fast_open": false,
    "workers":30
}
END

apt-get update

apt-get install supervisor

cat >/etc/supervisor/conf.d/shadowsocks.conf <<END
[program:shadowsocks]
command=ssserver -c /etc/shadowsocks.json
autorestart=true
user=root
END

cat >/etc/default/supervisor <<END
ulimit -n 51200
END

apt-get install python-m2crypto

apt-get install build-essential

wget https://github.com/jedisct1/libsodium/releases/download/1.0.3/libsodium-1.0.3.tar.gz

tar xf libsodium-1.0.3.tar.gz 

cd libsodium-1.0.3

./configure

make

make install

ldconfig

cd ../

rm -rf libsodium-1.0.3

rm libsodium-1.0.3.tar.gz

modprobe tcp_htcp

cat >/etc/sysctl.conf <<END
# max open files
fs.file-max = 51200
# max read buffer
net.core.rmem_max = 67108864
# max write buffer
net.core.wmem_max = 67108864
# default read buffer
net.core.rmem_default = 65536
# default write buffer
net.core.wmem_default = 65536
# max processor input queue
net.core.netdev_max_backlog = 4096
# max backlog
net.core.somaxconn = 4096

# resist SYN flood attacks
net.ipv4.tcp_syncookies = 1
# reuse timewait sockets when safe
net.ipv4.tcp_tw_reuse = 1
# turn off fast timewait sockets recycling
net.ipv4.tcp_tw_recycle = 0
# short FIN timeout
net.ipv4.tcp_fin_timeout = 30
# short keepalive time
net.ipv4.tcp_keepalive_time = 1200
# outbound port range
net.ipv4.ip_local_port_range = 10000 65000
# max SYN backlog
net.ipv4.tcp_max_syn_backlog = 4096
# max timewait sockets held by system simultaneously
net.ipv4.tcp_max_tw_buckets = 5000
# TCP receive buffer
net.ipv4.tcp_rmem = 4096 87380 67108864
# TCP write buffer
net.ipv4.tcp_wmem = 4096 65536 67108864
# turn on path MTU discovery
net.ipv4.tcp_mtu_probing = 1

# for high-latency network
net.ipv4.tcp_congestion_control = htcp
END

sysctl -p

service supervisor start

supervisorctl reload
