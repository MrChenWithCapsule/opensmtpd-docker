FROM golang:alpine AS build

RUN apk add --no-cache git
RUN git clone --depth=1 https://github.com/poolpOrg/filter-rspamd
RUN git clone --depth=1 https://github.com/poolpOrg/filter-senderscore
RUN cd filter-rspamd && go build && cd ../filter-senderscore && go build

FROM alpine

RUN apk add --no-cache opensmtpd \
    && adduser -h /var/mail/domains -s /sbin/nologin -S -D -g vmail vmail \
    && mkdir /var/spool/smtpd -m 711
COPY --from=build /go/filter-rspamd/filter-rspamd /go/filter-senderscore/filter-senderscore /usr/lib/opensmtpd/

VOLUME [ "/var/spool/smtpd" ]
EXPOSE 25
ENTRYPOINT [ "smtpd" ]
CMD [ "-d" ]
