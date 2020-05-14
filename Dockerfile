FROM alpine:latest

#add curl for better handling
RUN apk add --no-cache curl
RUN apk add linux-headers 
# Update & Install dependencies
RUN apk add --no-cache --update \
    git \
    bash \
    libffi-dev \
    openssl-dev \
    bzip2-dev \
    zlib-dev \
    readline-dev \
    sqlite-dev \
    build-base

# Set Python version
ARG PYTHON_VERSION='3.7.0'
RUN export PYTHON_VERSION
# Set pyenv home
ARG PYENV_HOME=/root/.pyenv
RUN export PYENV_HOME

# Install pyenv, then install python versions
RUN git clone --depth 1 https://github.com/pyenv/pyenv.git $PYENV_HOME && \
    rm -rfv $PYENV_HOME/.git

ENV PATH $PYENV_HOME/shims:$PYENV_HOME/bin:$PATH

RUN pyenv install $PYTHON_VERSION
RUN pyenv global $PYTHON_VERSION
RUN pip install --upgrade pip && pyenv rehash

# Clean
RUN rm -rf ~/.cache/pip

COPY start.sh /root/start.sh
RUN chmod +x  /root/start.sh


RUN mkdir -p /root/.config/deemix/ 

ENV DEEMIX_HOME=/root/.config/deemix/
ARG DEEMIX_HOME=/root/.config/deemix/
RUN export DEEMIX_HOME


#second test
RUN git clone --depth 1 https://notabug.org/RemixDev/deemix.git $DEEMIX_HOME && \
    rm -rfv $DEEMIX_HOME/.git
RUN pip install -r $DEEMIX_HOME/requirements.txt
#RUN /usr/bin/nohup python $DEEMIX_HOME/server.py

RUN \
     echo "************ customize deezloader ************" && \
     sed -i "s/\"trackNameTemplate\": \"%artist% - %title%\"/\"trackNameTemplate\": \"%disc%%number% - %title% %explicit%\"/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     sed -i "s/\"albumTrackNameTemplate\": \"%number% - %title%\"/\"albumTrackNameTemplate\": \"%disc%%number% - %title% %explicit%\"/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     # sed -i "s/\"createAlbumFolder\": true/\"createAlbumFolder\": false/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     sed -i "s/\"embeddedArtworkSize\": 800/\"embeddedArtworkSize\": 1400/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     sed -i "s/\"localArtworkSize\": 1000/\"localArtworkSize\": 1400/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     sed -i "s/\"queueConcurrency\": 3/\"queueConcurrency\": 6/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     sed -i "s/\"maxBitrate\": \"3\"/\"maxBitrate\": \"9\"/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     sed -i "s/\"coverImageTemplate\": \"cover\"/\"coverImageTemplate\": \"folder\"/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     sed -i "s/\"createCDFolder\": true/\"createCDFolder\": false/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     sed -i "s/\"removeAlbumVersion\": false/\"removeAlbumVersion\": true/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     sed -i "s/\"syncedlyrics\": false/\"syncedlyrics\": true/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     sed -i "s/\"logErrors\": false/\"logErrors\": true/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     sed -i "s/\"logSearched\": false/\"logSearched\": true/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     sed -i "s/\"trackTotal\": false/\"trackTotal\": true/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     sed -i "s/\"discTotal\": false/\"discTotal\": true/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     sed -i "s/\"publisher\": true/\"publisher\": false/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     sed -i "s/\"date\": true/\"date\": false/g" "$DEEMIX_HOME/deemix/app/default.json" && \
     sed -i "s/\"isrc\": true/\"isrc\": false/g" "$DEEMIX_HOME/deemix/app/default.json"




#works until here
#CMD ["python", "$DEEMIX_HOME/server.py"]
#RUN git clone --depth 1 https://notabug.org/RemixDev/deemix.git $DEEMIX_HOME && \
#    rm -rfv $DEEMIX_HOME/.git
#RUN pip install -r $DEEMIX_HOME/requirements.txt
#RUN python $DEEMIX_HOME/server.py
ENTRYPOINT ["/root/start.sh"]

EXPOSE 9666


