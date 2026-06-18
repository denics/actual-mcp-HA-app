ARG BUILD_FROM
FROM sstefanov/actual-mcp:latest

RUN apk add --no-cache bashio

COPY run.sh /run.sh
RUN chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]
