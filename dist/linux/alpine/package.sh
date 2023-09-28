#!/bin/sh

install -dm755 \
	"$pkgdir"/usr/Cryptomator \
	"$pkgdir"/usr/share/applications \
	"$pkgdir"/usr/share/icons/hicolor/scalable/apps \
	"$pkgdir"/usr/share/icons/hicolor/256x256/apps \
	"$pkgdir"/usr/share/icons/hicolor/512x512/apps \
	"$pkgdir"/usr/share/metainfo || exit 1

cp -a $_jpackage_dir/Cryptomator "$pkgdir"/usr || exit 1
cp -a dist/linux/alpine/org.cryptomator.Cryptomator.desktop "$pkgdir"/usr/share/applications || exit 1
cp -a dist/linux/common/org.cryptomator.Cryptomator.svg "$pkgdir"/usr/share/icons/hicolor/scalable/apps || exit 1
cp -a dist/linux/common/org.cryptomator.Cryptomator.tray.svg "$pkgdir"/usr/share/icons/hicolor/scalable/apps || exit 1
cp -a dist/linux/common/org.cryptomator.Cryptomator.tray-unlocked.svg "$pkgdir"/usr/share/icons/hicolor/scalable/apps || exit 1
cp -a dist/linux/common/org.cryptomator.Cryptomator256.png "$pkgdir"/usr/share/icons/hicolor/256x256/apps || exit 1
cp -a dist/linux/common/org.cryptomator.Cryptomator512.png "$pkgdir"/usr/share/icons/hicolor/512x512/apps || exit 1
cp -a dist/linux/common/org.cryptomator.Cryptomator.metainfo.xml "$pkgdir"/usr/share/metainfo || exit 1
