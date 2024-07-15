# ベースイメージとしてGoの公式イメージを使用
FROM golang:1.22

ADD . .

RUN go mod download && go build -o main cmd/app/main.go
RUN chmod u+x main
CMD ["./main"]