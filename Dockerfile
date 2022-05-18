FROM --platform=linux/amd64 ubuntu:20.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y clang cmake make

ADD . /repo
WORKDIR /repo/build
RUN cmake ../src
RUN make -j8
RUN ldconfig
