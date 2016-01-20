#!/usr/bin/env sh
yum install -y gluu-consumer
systemctl start docker.service && systemctl enable docker.service
systemctl start salt-minion.service && systemctl enable salt-minion.service

yum install -y gluu-agent
systemctl start gluu-agent.service && systemctl enable gluu-agent.service
