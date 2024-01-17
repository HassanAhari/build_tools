FROM ubuntu:20.04

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get -y install \
        apt-transport-https \
        autoconf2.13 \
        python2 \
        python3 \
        sudo \
        curl \
        wget \
        git \
        gzip \
        build-essential \
        ca-certificates \
        cmake \
        glib-2.0-dev \
        libgtk-3-dev \
        libpulse-dev \
        libtool \
        p7zip-full \
        subversion \
        libfontconfig1-dev \
        libfreetype6-dev \
        libgl1-mesa-dev \
        libglu1-mesa-dev \
        libicu-dev \
        libjpeg-dev \
        libpng-dev \
        libssl-dev \
        libx11-dev \
        libxcb1-dev \
        libxext-dev \
        libxfixes-dev \
        libxi-dev \
        libxrender-dev \
        libasound2-dev \
        libatspi2.0-dev \
        libcups2-dev \
        libdbus-1-dev \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        libx11-xcb-dev \
        libxcb* \
        libxss1 \
        libncurses5 \
        openjdk-11-jdk

RUN ln -s /usr/bin/python2 /usr/bin/python

# node 14 install
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

RUN npm install -g grunt-cli pkg 

# qt install ...
WORKDIR /qt
RUN wget https://download.qt.io/official_releases/qt/6.6/6.6.1/single/qt-everywhere-src-6.6.1.tar.xz \
    && tar -xf qt-everywhere-src-6.6.1.tar.xz
WORKDIR /qt/qt-everywhere-src-6.6.1
RUN ./configure -prefix /usr/local/Qt-6.6.1 -opensource -confirm-license -nomake examples -nomake tests -skip qtwebengine
RUN make -j $(nproc)
RUN make install
ENV PATH="/usr/local/Qt-6.6.1/bin:$PATH"
ENV QT_QPA_PLATFORM=offscreen

ADD . /build_tools
WORKDIR /build_tools

CMD cd tools/linux && \
    python3 ./automate.py
