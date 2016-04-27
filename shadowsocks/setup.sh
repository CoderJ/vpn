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

service supervisor start

supervisorctl reload
