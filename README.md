# Kirigami

Build on Android:
```
mkdir build
cd build

cmake ..  -DCMAKE_TOOLCHAIN_FILE=/path/to/share/ECM/toolchain/Android.cmake -DQTANDROID_EXPORTED_TARGET=kirigami2gallery -DANDROID_APK_DIR=../examples/android/ -DCMAKE_PREFIX_PATH=/path/to/Qt5.7.0/5.7/android_armv7/ -DCMAKE_INSTALL_PREFIX=/path/to/dummy/install/prefix -DBUILD_EXAMPLES=ON
```

You need a `-DCMAKE_INSTALL_PREFIX` to somewhere in your home, but using an absolute path

If you have a local checkout of the breeze-icons repo, you can avoid the cloning of the build dir
by passing also `-DBREEZEICONS_DIR=/path/to/existing/sources/of/breeze-icons`

```
make
make install
make create-apk-kirigami2gallery
```

`kirigamigallery_build_apk/bin/QtApp-debug.apk` will be generated

to directly install on a phone:
```
adb install -r ./kirigami2gallery_build_apk/bin/QtApp-debug.apk
```
