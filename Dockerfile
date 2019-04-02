FROM golang:1.11.1-alpine
# Dex connectors, such as GitHub and Google logins require root certificates.
# Proper installations should manage those certificates, but it's a bad user
# experience when this doesn't work out of the box.
#
# OpenSSL is required so wget can query HTTPS endpoints for health checking.
RUN apk add --no-cache --update alpine-sdk
RUN mkdir -p /home/go/gows
RUN chmod -R 777 /home/go
ADD gows /home/go/gows
ENV GOPATH "/home/go/gows"
RUN echo $GOPATH
RUN cd /home/go/gows/src/external_member && go install
RUN apk add --update ca-certificates openssl
RUN mkdir -p /home/log
RUN cp /home/go/gows/src/external_member/ext_member_config.json /home/go/gows/bin/ext_member_config.json
WORKDIR /home/go/gows/bin/
RUN pwd
ENTRYPOINT ["./external_member"]

CMD ["version"]
