FROM debian:testing-slim AS build
COPY filter-dkimsign/* ./
RUN sh build.sh

FROM debian:testing-slim
COPY --from=build /usr/local/libexec/smtpd/filter-dkimsign /usr/libexec/opensmtpd/filter-dkimsign
COPY --from=build /usr/lib/libopensmtpd.so /usr/lib/libopensmtpd.so
RUN apt-get update \
    && apt-get install -y opensmtpd opensmtpd-filter-senderscore \
    && echo opensmtpd > /etc/mailname \
    && mkdir -m 711 /var/spool/smtpd \
    && adduser --system --shell /sbin/nologin --home /var/vmail --group vmail

VOLUME [ "/var/spool/smtpd" ]
CMD [ "smtpd", "-d" ]
