mkdir tmp &&
cd tmp &&
git clone git@btsgo.net:fleamarket-app.git &&
cd ..
cp ./tmp/fleamarket-app/ios/Runner.xcodeproj/project.pbxproj ./ios/Runner.xcodeproj/project.pbxproj
cp ./tmp/fleamarket-app/ios/Runner.xcworkspace/contents.xcworkspacedata ./ios/Runner.xcworkspace/contents.xcworkspacedata &&
rm -rf tmp
