#!/usr/bin/env sh
yum install -y gluu-consumer #gluu-agent
systemctl start docker.service && systemctl enable docker.service
systemctl start salt-minion.service && systemctl enable salt-minion.service
