function get_num_cores() {
num_cores=`getconf _NPROCESSORS_ONLN`
retVal=$?
if [ $retVal -eq 0 ]; then
  return
fi

num_cores=`getconf NPROCESSORS_ONLN`
retVal=$?
if [ $retVal -eq 0 ]; then
  return
fi

$num_cores = 1
}


OUTPUT_DIR=./output/
mkdir -p $OUTPUT_DIR
EXTRACT_DIR="/tmp/btf/"
mkdir -p $EXTRACT_DIR
REDUCED_DIR=$OUTPUT_DIR"reduced/"
mkdir -p $REDUCED_DIR

files=`find ./ -type f -name '*.btf.tar.xz'`

get_num_cores
echo Num cores $num_cores
# for file in $files
# do
#  DIR="$(dirname "${file}")"
#  OUT_DIR=$REDUCED_DIR$DIR
#  mkdir -p $OUT_DIR
#  red_file=$REDUCED_DIR${file//.btf.tar.xz/.btf}
#  file_name=$(basename $file)
#  file_name=${file_name//.btf.tar.xz/.btf}
#  ex_file=$EXTRACT_DIR$file_name
#  echo Processing $file_name
#  tar xfJ $file -C $EXTRACT_DIR && bpftool gen min_core_btf $ex_file $red_file *.o && rm $ex_file &
#  while [ `ps -aux | grep "bpftool gen min_core_btf" | wc -l` -ge $num_cores ]
#  do 
#      sleep 0.002000
#   done
#  done


# echo $REDUCED_DIR
tar c --gz -f $OUTPUT_DIR/min_core_btfs.tar.gz -C $REDUCED_DIR .
cd $OUTPUT_DIR
ld -r -b binary min_core_btfs.tar.gz -o vmlinux_tcp_bpf.o

