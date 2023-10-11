# /bin/bash
WORK_DIR=$( mktemp -d )
ARM_FILE=$( mktemp -p $WORK_DIR )

python3 converter.py $1 $ARM_FILE
echo "---------------------------"

aarch64-linux-gnu-as $ARM_FILE -o $WORK_DIR/temp.o
aarch64-linux-gnu-ld $WORK_DIR/temp.o -lc -o $WORK_DIR/temp
qemu-aarch64 -L /usr/aarch64-linux-gnu/ $WORK_DIR/temp

rm -rf "$WORK_DIR"
exit 0