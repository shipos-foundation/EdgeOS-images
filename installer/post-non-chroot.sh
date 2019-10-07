#!/bin/bash

CHROOTPATH=$1

## -- clr-installer configuration -- 
mkdir -p ${CHROOTPATH}/var/lib/clr-installer/

cat >${CHROOTPATH}/var/lib/clr-installer/clr-installer.yaml <<'EOL'
---
bundles:
 - os-core
 - os-core-update
 - dolittle-edge
 - shipos-branding
users:
 - login: dolittle
   username: Dolittle Default User
   admin: true
   password: $6$UmdNOTE5nqWV/2HX$FGyFdMk6gKyV2xImJIylHxnDZ2Dc2rPtukuvclNjKc/yGG0AeafshywvI7RlzuaHemIXQAB6Ar9Ufr.cVVZ4X0
keyboard: us
language: en_US.UTF-8
timezone: UTC
kernel: kernel-lts
EOL

cat >${CHROOTPATH}/var/lib/clr-installer/bundles.json <<'EOL'
{
  "bundles": [
    {
      "name": "dolittle-edge-dell-5000",
      "desc": "Configuration for the Dell Embedded Box PC 5000"
    }
  ]
}
EOL

## -- Root autologin --
mkdir -p ${CHROOTPATH}/etc

echo 'root::::::::' > ${CHROOTPATH}/etc/shadow

mkdir -p ${CHROOTPATH}/usr/lib/systemd/system/getty@tty1.service.d/

cat >${CHROOTPATH}/usr/lib/systemd/system/getty@tty1.service.d/root-autologin.conf <<'EOL'
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin root --noclear %I $TERM
EOL

## -- Prettify the display a little --
mkdir -p ${CHROOTPATH}/etc

echo 'dolittle-edge-live' > ${CHROOTPATH}/etc/hostname

if [ -f "${CHROOTPATH}/usr/share/defaults/etc/issue" ]; then
  cat ${CHROOTPATH}/usr/share/defaults/etc/issue > ${CHROOTPATH}/etc/issue
else
  touch ${CHROOTPATH}/etc/issue
fi
cat >>${CHROOTPATH}/etc/issue <<'EOL'

  Ahoy! Welcome aboard the shipOS Edge Linux installer. To start the installation process, please run 'clr-installer' and follow the tutorial.
EOL

exit 0
