#!/usr/bin/env sh
yum install -y gluu-master

systemctl start docker.service && systemctl enable docker.service

systemctl start salt-master.service && systemctl enable salt-master.service
systemctl start salt-minion.service && systemctl enable salt-minion.service

firewall-cmd --permanent --add-port=4505-4506/tcp
firewall-cmd --reload

yum install -y gluu-flask

systemctl start gluu-flask.service && systemctl enable gluu-flask.service

yum install -y gluu-agent

systemctl start gluu-agent.service && systemctl enable gluu-agent.service

mv /usr/share/oxd-license-validator/oxd-license-validator-3.0.1-SNAPSHOT-jar-with-dependencies.jar /usr/share/oxd-license-validator/oxd-license-validator.jar
