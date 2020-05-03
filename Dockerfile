FROM ubuntu:18.04

ENV GO_VERSION=1.14.2 \
    GOPATH="/root/go" \
    GOBIN="/root/go/bin" \
    PROTOC_VERSION=3.7.1 \
    PROTOC_ZIP=protoc-3.7.1-linux-x86_64.zip \
    NVM_VERSION=0.35.3 \
    NVM_DIR=/usr/local/nvm \
    NODE_VERSION=12.16.2 \
    PATH="/usr/local/go/bin/:/usr/local/nvm/bin/:/root/go/bin/:$PATH"

RUN env

WORKDIR /root

## Install Tools
RUN apt-get update \
    && apt-get install -y \
        curl \
        wget \
        unzip \
        git \
        build-essential \
        libssl-dev


## Install Go
ENV GO_VERSION ${GO_VERSION}
RUN wget https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && echo 'export GOPATH=$HOME/go' >> /root/.bashrc \
    && echo 'export GOBIN=$HOME/go/bin' >> /root/.bashrc \
    && echo 'export PATH=$PATH:/usr/local/go/bin:$(go env GOBIN)' >> /root/.bashrc

## Install Protoc
RUN curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/$PROTOC_ZIP \
    && unzip -o $PROTOC_ZIP -d /usr/local bin/protoc \
    && unzip -o $PROTOC_ZIP -d /usr/local 'include/*' \
    && rm -f $PROTOC_ZIP

SHELL ["/bin/bash", "-c"]
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y \
    && . /root/.cargo/env \
    && mkdir $NVM_DIR \
    && wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm use --delete-prefix $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && nvm current \
    && git clone https://github.com/hdac-io/friday.git \
    && cd friday \
    && npm install -g assemblyscript@0.9.1 \
    && make install \
    && nodef version \
    && clif version

ENTRYPOINT ["/bin/bash"]