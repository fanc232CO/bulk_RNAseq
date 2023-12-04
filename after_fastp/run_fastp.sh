dir_fastp=/home/fanc232/softwares/fastp/
function run_fastp(){
    bn=$1
    f1=../ori/${bn}.R1.fastq.gz
    f2=../ori/${bn}.R2.fastq.gz
    $dir_fastp/fastp -i $f1 -o ./${bn}_fastp_1.fq.gz -I $f2 -O ./${bn}_fastp_2.fq.gz
}
for i in $(cat ../ori/bn.list);do
    #echo $i
    run_fastp $i
done
