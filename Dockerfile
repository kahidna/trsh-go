FROM golang:1.13.15-alpine3.12 AS builder

RUN mkdir -p /app && apk add git && go get -u "gopkg.in/telegram-bot-api.v4"

WORKDIR /app

ADD . /app

RUN go build ./trsh.go

# ----------------------------------------------------------------------
FROM alpine:latest

# Set the working directory
WORKDIR /usr/local/bin

RUN apk add gcompat bash openssh-client net-tools curl wget zip 

# Copy the compiled binary from the 'builder' stage
# The 'app' binary is copied to the final image
COPY --from=builder /app/trsh .

WORKDIR /root

CMD ["/usr/local/bin/trsh"]
