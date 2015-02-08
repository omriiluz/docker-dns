#!/bin/bash
# socat and nc hacks can be replaced with curl 7.40 once it's out

function refresh_hosts(){

  socat TCP-L:2375,fork UNIX:/var/run/docker.sock &
  SOCAT_PID=$!
  echo "Started socat proxy PID $SOCAT_PID"

  URL=http://localhost:2375/containers
  rm /tmp/hosts
  for ID in $(curl -s $URL/json | jq '.[].Id'|tr -d '"'); do curl -s $URL/${ID}/json | jq '.NetworkSettings.IPAddress+" "+.Name'|tr -d '"/'>>/tmp/hosts; done;

  echo "Recreated hosts file"
  cat /tmp/hosts

  kill -SIGHUP $(cat /var/run/dnsmasq.pid)
  echo "Refreshed dnsmasq cache"

  kill $SOCAT_PID
  echo "Killed socat proxy"
}

function process_event(){
  #filter only json (starting with {)
  if [[ $1 == {* ]]
  then
    echo $1 | jq .
    refresh_hosts
  #else
    # echo "Ignoring input $1"
  fi

}

echo "starting dnsmasq"
dnsmasq
sleep 1

while [ 1 ];
do
  refresh_hosts
  echo -e "GET /events HTTP/1.1\r\n" | nc -U /var/run/docker.sock | while read event; do process_event $event; done
  echo "Unexpected exit of events monitor, retrying in 1 second"
  sleep 1
done
