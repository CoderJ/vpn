apt-get install curl
curl 'https://raw.githubusercontent.com/shadowsocks/stackscript/master/stackscript.sh?v=4' > /tmp/ss.sh && bash /tmp/ss.sh && rm /tmp/ss.sh

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

pip install https://github.com/shadowsocks/shadowsocks/archive/master.zip

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
