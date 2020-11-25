mkdir tmp &&
cd tmp &&
git clone git@btsgo.net:fleamarket-app.git &&
git checkout xndev && git reset --hard 2bcb1bb5966ea786cc1c7248c926ad822b137cd4 &&
cd ..
cp ./tmp/fleamarket-app/ios/Runner.xcodeproj/project.pbxproj ./ios/Runner.xcodeproj/project.pbxproj
cp ./tmp/fleamarket-app/ios/Runner.xcworkspace/contents.xcworkspacedata ./ios/Runner.xcworkspace/contents.xcworkspacedata &&
rm -rf tmp
