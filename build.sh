#!/bin/bash
set -ex

base=$(dirname $0)
overlay_base=$base/DisplayCutoutEmulationInvisibleOverlay
module_base=$base/module

aapt2 compile -v --dir $overlay_base/res/ -o res.zip
aapt2 link -v --manifest $overlay_base/AndroidManifest.xml res.zip -I $overlay_base/android-31.jar -o linked.apk
zipalign -v -f 4 linked.apk aligned.apk
test -f keystore.jks || keytool -genkey -v -keystore keystore.jks -storepass 123456 -keyalg RSA -keysize 2048 -dname 'CN=localhost' -validity 3650
apksigner sign -v --ks keystore.jks --ks-pass pass:123456 --out signed.apk aligned.apk
rm res.zip linked.apk aligned.apk # keystore.jks

cp -r $module_base ./
mkdir -p module/system/product/overlay/DisplayCutoutEmulationInvisible
cd module
cp ../signed.apk system/product/overlay/DisplayCutoutEmulationInvisible/DisplayCutoutEmulationInvisibleOverlay.apk
zip ../module.zip -r .
cd ..
rm -r module