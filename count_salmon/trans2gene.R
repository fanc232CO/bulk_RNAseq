#!/home/fanc232/bin/Rscript
#transform transcript-level counts to gene-level
#strip the version number in ensemble ids
Args=commandArgs(TRUE)
ct_trans<-read.table('./quant.sf',header = T, stringsAsFactors = F)
strip_v<-function(id){
  l=strsplit(id,'[.]')
  id2=l[[1]][1]
  return(id2)
}
l_id<-unlist(lapply(ct_trans$Name,strip_v))
ct_trans$Name<-l_id
write.table(ct_trans,'quant_noid.sf',row.names = F,sep='\t',quote = F)
df_map<-read.table(Args[1],header = T,stringsAsFactors = F)
tx2gene<-df_map[,c(1,2)]
library('tximport')
obj<-tximport(file='./quant_noid.sf',type='salmon',tx2gene = tx2gene) #raw counts
#obj<-tximport(file='./quant_noid.sf',type='salmon',countsFromAbundance="scaledTPM",tx2gene = tx2gene)
#abundance, counts, length in obj.
ct_gene<-as.data.frame(obj[[2]]) #raw counts
#tpm_gene<-as.data.frame(obj[[2]])
write.table(ct_gene,'quant.genes.sf') #raw counts
#write.table(tpm_gene,'quant.genes.scalTPM.sf')
