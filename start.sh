#!/bin/sh
echo "server.py start"


#git clone --depth 1 https://notabug.org/RemixDev/deemix.git $DEEMIX_HOME && \
#    rm -rfv $DEEMIX_HOME/.git   
#pip install -r $DEEMIX_HOME/requirements.txt


/usr/bin/nohup python $DEEMIX_HOME/server.py
