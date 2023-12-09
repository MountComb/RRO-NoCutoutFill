mkdir -p DisplayCutoutEmulationInvisibleOverlay/build
cd DisplayCutoutEmulationInvisibleOverlay/build

aapt2 compile --dir ../res/ -o res.zip
aapt2 link --manifest ../AndroidManifest.xml res.zip --warn-manifest-validation -I ../android-31.jar -o linked.apk
zipalign -f 4 linked.apk aligned.apk
keytool -genkey -keystore keystore.jks -storepass 123456 -keyalg RSA -keysize 2048 -dname 'CN=localhost' -validity 3650
apksigner sign --ks keystore.jks --ks-pass pass:123456 --out signed.apk aligned.apk

cd ../..

