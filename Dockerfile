FROM golang:1.13 AS builder

RUN mkdir -p /app

WORKDIR /app

RUN go get -u "gopkg.in/telegram-bot-api.v4"
RUN apt update -y
RUN apt install -y mtr dnsutils nmap net-tools

ADD . /app

RUN go build ./trsh.go

# ----------------------------------------------------------------------
FROM alpine:latest

# Set the working directory
WORKDIR /usr/local/bin

RUN apk add gcompat bash openssh-client net-tools

# Copy the compiled binary from the 'builder' stage
# The 'app' binary is copied to the final image
COPY --from=builder /app/trsh .

WORKDIR /root

CMD ["/usr/local/bin/trsh"]
