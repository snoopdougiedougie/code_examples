FROM golang

COPY . /src/microservice

RUN cd /src/microservice && CGO_ENABLED=0 go install

ENV PORT 8080
EXPOSE 8080

ENTRYPOINT microservice