protoc --dart_out=grpc:./ -I. \
-I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
 ./bitsflea.proto 