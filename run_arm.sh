# /bin/bash

MODE=0

usage () {
    cat << EOF
Usage: $(basename $0) [-hd] [ARM file]
    -h: Display help
    -d: Enter debug mode
    [ARM file]: .s file
EOF
}

while getopts ":hd" options; do
    case "${options}" in  
        h)
            usage
            exit 0
            ;;  
        d)
            MODE=1
            ;;
        *)
            echo "Error: Unknown option '-"$OPTARG"'." 1>&2
            usage
            exit 1
            ;;        
    esac
done
shift $((OPTIND-1))

WORK_DIR=$( mktemp -d )

if [[ MODE -eq 0 ]]; then
    aarch64-linux-gnu-as -o $WORK_DIR/temp.o $1
    aarch64-linux-gnu-ld -lc -o $WORK_DIR/temp $WORK_DIR/temp.o 
    qemu-aarch64 -L /usr/aarch64-linux-gnu/ $WORK_DIR/temp
else
    aarch64-linux-gnu-as -o $WORK_DIR/temp.o -g $1
    aarch64-linux-gnu-ld -lc -o $WORK_DIR/temp $WORK_DIR/temp.o
    qemu-aarch64 -L /usr/aarch64-linux-gnu/ -g 1234 $WORK_DIR/temp &

    gdb-multiarch --nh -q $WORK_DIR/temp -ex 'set disassemble-next-line on' -ex 'target remote :1234' -ex 'set solib-search-path /usr/aarch64-linux-gnu-lib/' -ex 'layout regs'
fi

rm -rf "$WORK_DIR"
exit 0