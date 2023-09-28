#!/bin/sh

mvn package -Pdependency-check,linux -DskipTests || exit 1

cp target/cryptomator-*.jar target/mods || exit 1
cp LICENSE.txt target || exit 1

$JAVA_HOME/bin/jlink \
	--verbose \
	--output $_jlink_dir \
	--module-path "/usr/lib/openjfx$_openjfx_major_version:openjfx-jmods" \
	--add-modules java.base,java.desktop,java.instrument,java.logging,java.naming,java.net.http,java.scripting,java.sql,java.xml,javafx.base,javafx.graphics,javafx.controls,javafx.fxml,jdk.unsupported,jdk.crypto.ec,jdk.security.auth,jdk.accessibility,jdk.management.jfr,jdk.net \
	--strip-native-commands \
	--no-header-files \
	--no-man-pages \
	--strip-debug \
	--compress=1 || exit 1

SEMVER_STR="$pkgver"
REVISION_NUM=$pkgver

envsubst '${SEMVER_STR} ${REVISION_NUM' < dist/linux/launcher-gtk2.properties > launcher-gtk2.properties || exit 1

$JAVA_HOME/bin/jpackage \
	--verbose \
	--type app-image \
	--runtime-image $_jlink_dir \
	--input target/libs \
	--module-path target/mods \
	--module org.cryptomator.desktop/org.cryptomator.launcher.Cryptomator \
	--dest $_jpackage_dir \
	--name Cryptomator \
	--vendor "Skymatic GmbH" \
	--copyright "(C) 2016 - 2023 Skymatic GmbH" \
	--app-version "$pkgver" \
	--java-options "--enable-preview" \
	--java-options "--enable-native-access=org.cryptomator.jfuse.linux.amd64,org.cryptomator.jfuse.linux.aarch64,org.purejava.appindicator" \
	--java-options "-Xss5m" \
	--java-options "-Xmx256m" \
	--java-options "-Dcryptomator.appVersion=\"$pkgver\"" \
	--java-options "-Dfile.encoding=\"utf-8\"" \
	--java-options "-Djava.net.useSystemProxies=true" \
	--java-options "-Dcryptomator.logDir=\"@{userhome}/.local/share/Cryptomator/logs\"" \
	--java-options "-Dcryptomator.pluginDir=\"@{userhome}/.local/share/Cryptomator/plugins\"" \
	--java-options "-Dcryptomator.settingsPath=\"@{userhome}/.config/Cryptomator/settings.json:@{userhome}/.Cryptomator/settings.json\"" \
	--java-options "-Dcryptomator.p12Path=\"@{userhome}/.config/Cryptomator/key.p12\"" \
	--java-options "-Dcryptomator.ipcSocketPath=\"@{userhome}/.config/Cryptomator/ipc.socket\"" \
	--java-options "-Dcryptomator.mountPointsDir=\"@{userhome}/.local/share/Cryptomator/mnt\"" \
	--java-options "-Dcryptomator.showTrayIcon=true" \
	--java-options "-Dcryptomator.integrationsLinux.trayIconsDir=\"@{appdir}/usr/share/icons/hicolor/symbolic/apps\"" \
	--java-options "-Dcryptomator.buildNumber=\"appimage-$pkgver\"" \
	--java-options "-Dprism.verbose=true" \
	--add-launcher Cryptomator-gtk2=launcher-gtk2.properties \
	--resource-dir dist/linux/resources || exit 1
