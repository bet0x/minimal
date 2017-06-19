#!/bin/sh
SRC_DIR=$(pwd)

# Find the main source directory
cd ../../..
MAIN_SRC_DIR=$(pwd)
cd $SRC_DIR

# Read the 'CFLAGS' property from '.config'
CFLAGS="$(grep -i ^CFLAGS $MAIN_SRC_DIR/.config | cut -f2 -d'=')"

echo "removing previous work area"
rm -rf $MAIN_SRC_DIR/work/overlay/nweb
mkdir -p $MAIN_SRC_DIR/work/overlay/nweb
cd $MAIN_SRC_DIR/work/overlay/nweb

# nweb
cc $CFLAGS $SRC_DIR/nweb23.c -o nweb

# client
#cc $CFLAGS $SRC_DIR/client.c -o client

echo "nweb has been build."

install -d -m755 "$MAIN_SRC_DIR/work/src/minimal_overlay/rootfs/usr"
install -d -m755 "$MAIN_SRC_DIR/work/src/minimal_overlay/rootfs/usr/bin"
install -m755 nweb "$MAIN_SRC_DIR/work/src/minimal_overlay/rootfs/usr/bin/nweb"
#install -m755 client "$MAIN_SRC_DIR/work/src/minimal_overlay/rootfs/usr/bin/client"
install -d -m755 "$MAIN_SRC_DIR/work/src/minimal_overlay/rootfs/srv/www" # FHS compliant location
install -m644 "$SRC_DIR/index.html" "$MAIN_SRC_DIR/work/src/minimal_overlay/rootfs/srv/www/index.html"
install -m644 "$SRC_DIR/favicon.ico" "$MAIN_SRC_DIR/work/src/minimal_overlay/rootfs/srv/www/favicon.ico"
install -d -m755 "$MAIN_SRC_DIR/work/src/minimal_overlay/rootfs/etc"
install -m755 "$SRC_DIR/nweb.sh" "$MAIN_SRC_DIR/work/src/minimal_overlay/rootfs/etc/autorun/90_nweb.sh"

echo "nweb has been installed."
echo "it will be autostarted on boot"
