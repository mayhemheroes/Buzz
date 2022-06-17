FROM --platform=linux/amd64 ubuntu:20.04 as builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y clang cmake make

COPY . /repo
WORKDIR /repo/build
RUN cmake ../src
RUN make -j8
RUN ldconfig

RUN mkdir -p /deps
RUN ldd /repo/build/buzz/bzzasm | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /repo/build/buzz/bzzasm /repo/build/buzz/bzzasm
ENV LD_LIBRARY_PATH=/deps
