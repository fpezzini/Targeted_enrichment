#FIRST:bwa index ceiba2.fna ceiba2

#! /bin/bash -x
# using bwa to generate sam/bam files
# Flavia Pezzini 30 november 2017 | modified from Catherine Kidner bam_me.sh
# Output from trimmomatic

echo "Hello world"

acc=$1

echo "Working on $1"
#score=G,190,8
fwd_p=../${acc}_trimmed_1.fastq
rev_p=../${acc}_trimmed_2.fastq
#un_p=${acc}_trimmed_1u.fastq,${acc}_trimmed_2u.fastq
sam=${acc}.sam
index=${acc}_sorted.bam
pileup=${acc}.pileup
vcf=${acc}.vcf
bowtie=${acc}_bowtie_output
sorted=${acc}_sorted

#bowtie2 --local --score-min $score -x Ceiba_unique_baits -1 $fwd_p  -2 $rev_p  -U $un_p  -S $sam 2>$bowtie
bwa mem -t 16 ceiba2.fna $fwd_p $rev_p > $sam
samtools view -bS $sam | samtools sort - $sorted
samtools index $index
samtools mpileup -E -uf ceiba2.fna  $index > $pileup
bcftools view -cg $pileup > $vcf
rm *.sam
rm *.pileup

exit 0

