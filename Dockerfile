FROM alpine:edge AS build
COPY filter-dkimsign/* ./
RUN sh build.sh

FROM alpine:edge
COPY --from=build /usr/local/libexec/smtpd/filter-dkimsign /usr/libexec/opensmtpd/filter-dkimsign
COPY --from=build /usr/lib/libopensmtpd.so /usr/lib/libopensmtpd.so
RUN apk update \
    && apk add opensmtpd opensmtpd-filter-senderscore ca-certificates
RUN echo opensmtpd > /etc/mailname \
    && mkdir -m 711 /var/spool/smtpd \
    && adduser -S -s /sbin/nologin -h /var/vmail -G vmail \
    && adduser -S -u 957 -s /sbin/nologin -h /var/empty -G dkimsign

VOLUME [ "/var/spool/smtpd" ]
CMD [ "smtpd", "-d", "-f", "/srv/config/smtpd.conf" ]
