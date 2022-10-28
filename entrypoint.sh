#!/bin/sh

# args
CADDYIndexPage="https://raw.githubusercontent.com/caddyserver/dist/master/welcome/index.html"
# CONFIGCADDY="https://raw.githubusercontent.com/kiujhyt/xray3/master/etc/Caddyfile"
# CONFIGXRAY="https://raw.githubusercontent.com/kiujhyt/xray3/master/etc/xray.json"
ParameterSSENCYPT="chacha20-ietf-poly1305"
AUUID="4abab2b5-16cc-4c4f-8bfb-887489f5dc82"
#PORT=80


# configs
# mkdir -p /etc/caddy/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt
mkdir -p /etc/caddy/ /etc/xray/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt
# wget $CADDYIndexPage -O /usr/share/caddy/index.html && unzip -qo /usr/share/caddy/index.html -d /usr/share/caddy/ && mv /usr/share/caddy/*/* /usr/share/caddy/
wget $CADDYIndexPage -O /usr/share/caddy/index.html 
# wget -qO- $CONFIGCADDY | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $AUUID)/g" >/etc/caddy/Caddyfile
# wget -qO- $CONFIGXRAY | sed -e "s/\$AUUID/$AUUID/g" -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" >/etc/xray/config.json
cat /conf/Caddyfile | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $AUUID)/g" >/etc/caddy/Caddyfile
cat /conf/xray.json | sed -e "s/\$AUUID/$AUUID/g" -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" >/etc/xray/config.json

# start
tor &
xray -config /etc/xray/config.json &
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile