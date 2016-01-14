#!/usr/bin/env sh
yum install -y gluu-master #gluu-flask gluu-agent
systemctl start docker.service
systemctl enable docker.service
systemctl start salt-master.service
systemctl enable salt-master.service
systemctl start salt-minion.service
systemctl enable salt-minion.service
# systemctl start gluu-flask.service
# systemctl enable gluu-flask.service
