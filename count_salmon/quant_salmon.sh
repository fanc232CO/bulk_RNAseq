#!/bin/bash
#remember to conda activate salmon first!!!

#first, generate salmon index using reference genome.
#salmon index -t /share/home/fancong/database_fan/ref_genome/human/Homo_sapiens.GRCh38.cdna.all.fa -i human_index -p 10 > gen_index.log
#dir_human_index=/mnt/fanc/salmon_human_index
dir_mouse_index=/mnt/fanc/ref_genome/mouse/mouse_index

#then quantitative
salmon_quant(){
	fname=$1
	f1=../after_fastp/${fname}_fastp_1.fq.gz
	f2=../after_fastp/${fname}_fastp_2.fq.gz
	#salmon quant -i human_index -l A -1 $f1 -2 $f2 -p 4 -g /share/home/fancong/database_fan/ref_genome/human/Homo_sapiens.GRCh38.102.gtf -o ${fname}_quant #estimate both in gene and isoform level. gtf was transformed by gffread tool from NCBI gff file.
	salmon quant -i $dir_mouse_index -l A -1 $f1 -2 $f2 -p 4 -o ${fname}_quant #use tximport instead!
}

for fname in $(cat ../ori/bn.list);do
	echo $fname
	#salmon_quant $fname
	cd ${fname}_quant
	#/usr/bin/Rscript ../trans2gene.R /mnt/fanc/ref_genome/trans2gene/GRCh38.102.map #change this Rscript to get TPM or raw counts!
	/usr/bin/Rscript ../trans2gene.R /mnt/fanc/ref_genome/trans2gene/GRCm38.102_uniq.map #for mouse!
	cd ..
done > run_salmon.log
