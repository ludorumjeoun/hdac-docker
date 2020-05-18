FROM ubuntu:18.04

ENV GO_VERSION=1.14.2 \
    GOPATH="/root/go" \
    GOBIN="/root/go/bin" \
    PROTOC_VERSION=3.7.1 \
    PROTOC_ZIP=protoc-3.7.1-linux-x86_64.zip \
    NVM_VERSION=0.35.3 \
    NVM_DIR=/usr/local/nvm \
    NODE_VERSION=12.16.2 \
    PATH="/usr/local/go/bin/:/usr/local/nvm/bin/:/root/go/bin/:/root/.cargo/bin:$PATH"

RUN env

WORKDIR /root

## Install Tools
RUN apt-get update \
    && apt-get install -y \
        curl \
        wget \
        vim \
        unzip \
        git \
        cmake \
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
    && npm install -g assemblyscript@0.9.1 \
    && git clone https://github.com/hdac-io/friday.git \
    && cd friday \
    && git checkout tags/v0.9.0 \
    && make install \
    && nodef version \
    && clif version

ENV HDAC_NODE_NAME="mynode" \
    HDAC_CHAIN_ID="monday-0009" \ 
    HDAC_LAUNCH_COMMIT="2bc3093210a1b9a68f9838ba89c438dc20740145" \
    HDAC_SEED_LIST='"fedf0aba3dd9059a3d42dfb6ca4838a69a16cad6412d7734370233d84d1bcf06@13.124.50.97:26656,c5af92ef83a32821692a87d18670724e28903b5b2efbb97c666428d6a24efdbf@54.180.153.226:26656,c9b0d45c98304c6ea7a90e46b4867d30f9a49ed2ccb92d23089112ff82e835b5@13.124.253.195:26656,01e5993fa8180f37206d9c4b02ba4ef2134473933bbb937d6b91c940adb249eb@3.34.5.208:26656"'


RUN nodef init "$HDAC_NODE_NAME" tendermint --chain-id "$HDAC_CHAIN_ID" \
    && curl -L "https://raw.githubusercontent.com/hdac-io/launch/$HDAC_LAUNCH_COMMIT/genesis.json" -o /root/.nodef/config/genesis.json \
    && curl -L "https://raw.githubusercontent.com/hdac-io/launch/$HDAC_LAUNCH_COMMIT/manifest.toml" -o /root/.nodef/config/manifest.toml \ 
    && sed -i "s/^\(seeds\s*=\s*\).*\$/\1$HDAC_SEED_LIST/" /root/.nodef/config/config.toml

RUN apt-get install -y \
        net-tools \
        jq 

CMD /root/friday/CasperLabs/execution-engine/target/release/casperlabs-engine-grpc-server /root/.casperlabs/.casper-node.sock -z & \
    nodef start
