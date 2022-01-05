FROM alpine

RUN apk update

RUN apk add ncurses-dev gcc libc-dev flex bison linux-headers make git

COPY debugrc /root/.nethackrc

WORKDIR /app

RUN git clone --depth 1 https://github.com/Chris-plus-alphanumericgibberish/dNAO.git --branch devel-3.21.2 dnh

RUN cd dnh && sed -i -e "s/\/\* set nvrange \*\//iflags.debug_fuzzer = 1;/" src/u_init.c
#RUN cd dnh && sed -i -e "s/\/\* set nvrange \*\//*(int *)u.ux=0;/" src/u_init.c

RUN cd dnh && make -j 4 install

RUN mv /app/dnh/dnethackdir /

RUN rm -rf /app

WORKDIR /dnethackdir/

CMD sysctl -w kernel.core_pattern=/cores/core-%e.%p.%h.%t && /dnethackdir/dnethack -D -u `hostname`
