FROM rockylinux:9.2 as build

ENV FIO_VERSION 3.35

RUN dnf update -y \
    && dnf -y install wget make gcc \
    && dnf clean all

RUN wget "https://github.com/axboe/fio/archive/refs/tags/fio-$FIO_VERSION.tar.gz" \
    && tar xf fio-$FIO_VERSION.tar.gz \
    && mv fio-fio-$FIO_VERSION fio

RUN cd fio \
    && ./configure \
    && make



FROM rockylinux:9.2-minimal

RUN microdnf update -y \
    && microdnf -y install make \
    && microdnf clean all

COPY --from=build /fio /fio

RUN cd fio \
    && make install \
    && cd .. \
    && rm -rf fio

CMD "fio"