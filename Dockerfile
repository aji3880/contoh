FROM golang:1.22 as builder

WORKDIR /app
COPY . .
RUN go mod init go-ocp-app && go build -o app main.go

FROM registry.access.redhat.com/ubi8/ubi-minimal
WORKDIR /app
COPY --from=builder /app/app .
EXPOSE 8080
CMD ["./app"]