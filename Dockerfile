FROM golang:1.9.2 as builder
WORKDIR /build/
COPY ipcamproxy.go    .
RUN CGO_ENABLED=0 GOOS=linux go build -o ipcamproxy .

FROM scratch
COPY --from=builder /build/ipcamproxy .
ENTRYPOINT ["/ipcamproxy"]
CMD ["http://via.placeholder.com:80/350x150","false"]