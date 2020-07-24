PROTOC="protoc -I$PROTOBUF -I$GOOGLEAPIS -I./ --dart_out=grpc:./"

$PROTOC $PROTOBUF/google/protobuf/any.proto
$PROTOC $PROTOBUF/google/protobuf/wrappers.proto
$PROTOC ./bitsflea.proto

dartfmt -w .