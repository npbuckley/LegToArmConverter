# /bin/bash
WORK_DIR=$( mktemp -d )

aarch64-linux-gnu-as $1 -o $WORK_DIR/temp.o
aarch64-linux-gnu-ld $WORK_DIR/temp.o -lc -o $WORK_DIR/temp
$WORK_DIR/temp

rm -rf "$WORK_DIR"
exit 0