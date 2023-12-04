#!/bin/bash
#conda activate!!!
fn_conf=/mnt/fanc/fastq_screen_db/fastq_screen.conf
function get_speci(){
    bn=$1
    f1=../ori/${bn}.R1.fastq.gz
    f2=../ori/${bn}.R2.fastq.gz
    fastq_screen --conf $fn_conf $f1 $f2
}
for i in $(cat bn.list);do
    get_speci $i
done
