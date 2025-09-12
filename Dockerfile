# Build stage
FROM golang:1.22 AS builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app .

# Runtime stage
FROM scratch
COPY --from=builder /src/app /app
ENTRYPOINT ["/app"]
