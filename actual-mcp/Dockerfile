ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache bashio

COPY run.sh /run.sh
RUN chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]
