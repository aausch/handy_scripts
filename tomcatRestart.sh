#!/bin/bash	
ssh -tt $1 <<EOF
sudo service tomcat7 restart
EOF