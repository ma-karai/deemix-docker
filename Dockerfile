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
# Set pyenv home
ARG PYENV_HOME=/root/.pyenv

# Install pyenv, then install python versions
RUN git clone --depth 1 https://github.com/pyenv/pyenv.git $PYENV_HOME && \
    rm -rfv $PYENV_HOME/.git

ENV PATH $PYENV_HOME/shims:$PYENV_HOME/bin:$PATH

RUN pyenv install $PYTHON_VERSION
RUN pyenv global $PYTHON_VERSION
RUN pip install --upgrade pip && pyenv rehash

# Clean
RUN rm -rf ~/.cache/pip

#works until here
RUN mkdir -p /root/.config/deemix/ 
ARG DEEMIX_HOME=/root/.config/deemix/

RUN git clone --depth 1 https://notabug.org/RemixDev/deemix.git $DEEMIX_HOME && \
    rm -rfv $DEEMIX_HOME/.git

RUN pip install -r $DEEMIX_HOME/requirements.txt

CMD ["python", "$DEEMIX_HOME/server.py"]
# does not work
#RUN python $DEEMIX_HOME/server.py



