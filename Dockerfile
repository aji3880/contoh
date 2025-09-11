FROM golang:1.22 AS builder
WORKDIR /app
COPY . .
RUN go mod init contoh && \
    go mod tidy && \
    go build -o contoh

    FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=builder /app/contoh .
CMD ["./contoh"]
