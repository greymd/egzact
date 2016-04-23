FROM ubuntu:14.04
MAINTAINER Yamada, Yasuhiro <greengregson@gmail.com>
RUN echo 'nameserver 8.8.8.8' > /etc/resolv.conf && \
    apt-get update && \
    apt-get install -y haskell-platform libncurses-dev git make && \
    cabal update && \
    cabal install egison egison-tutorial && \
    # cabal install glob test-framework-hunit && \ # For testing
    echo 'PATH=$PATH:$HOME/.cabal/bin' >> ~/.bashrc && \
    echo 'PATH=$PATH:$HOME/.egison/bin' >> ~/.bashrc && \
    cd ~/ && \
    git clone https://github.com/greymd/egzact.git && \
    cd ~/egzact && \
    # sh test.sh && \ # For testing
    make install
