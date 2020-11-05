#!/bin/bash

echo "creating htpass...using the same for Grafana"
echo -n Password:
read -s password
echo

htpasswd -cb htapass/grafana_users admin ${password}
htpasswd -cb htapass/prometheus_users admin ${password}
htpasswd -cb htapass/conkolla_users admin ${password}
htpasswd -cb htapass/traefik_users admin ${password}

sed -i "s/secret/${password}/" grafana/config.monitoring




read -p "Continue with host name settings (y/n)?" choice
case "$choice" in
  y|Y ) echo "yes";;
  n|N ) exit 0;;
  * ) echo "invalid";;
esac



domain=packnot.com
echo -n "suffix for host names for {grafana-<>, prometheus-<>,conkolla-<>,traefik-<>}.${domain}".
echo -n "Suffix:"
read suffix

sed -i "s/conkolla-/conkolla-${suffix}.${domain}/" docker-appgate-monitor-stack.yml
sed -i "s/traefik-/traefik-${suffix}.${domain}/" docker-appgate-monitor-stack.yml
sed -i "s/prometheus-/prometheus-${suffix}.${domain}/" docker-appgate-monitor-stack.yml
sed -i "s/grafana-/grafana-${suffix}.${domain}/" docker-appgate-monitor-stack.yml

sed -i "s/host/https:\/\/grafana-${suffix}.${domain}/" grafana/config.monitoring

echo "My IP: add to DNS records for {conkolla, grafana, traefik, prometheus}-${suffix}.${domain} pointing to IP:"
curl ifconfig.me
echo ""
echo "done."
