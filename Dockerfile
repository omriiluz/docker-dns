FROM ubuntu

MAINTAINER omri@iluz.net

VOLUME [ "/etc/dnsmasq.d" ]
RUN apt-get install -y software-properties-common --force-yes
RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
RUN apt-get update
RUN apt-get install -y dnsmasq-base
RUN apt-get install --no-install-recommends -y dnsutils socat jq curl
RUN touch /tmp/hosts

ADD files /root/dnsmasq_files
ADD files/redirect /bin/redirect
RUN chmod +x /bin/redirect
ADD files/dnsmasq.conf /etc/dnsmasq.conf

EXPOSE 53

CMD ["/root/dnsmasq_files/run.sh"]
