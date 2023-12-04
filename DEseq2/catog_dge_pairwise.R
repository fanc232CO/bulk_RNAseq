#DEseq analysis
#compare with NC
rm(list=ls())
load('../pre_proc/preproc_expr.RData')
df_gp<-read.csv('../expr/df_group.csv',header = T, stringsAsFactors = F)
#transform sample list, it seemed string such as 'A-B' will transformed to 'A.B' in df_expr
trans_id<-function(id){
  l<-strsplit(id,split = '-')
  id1<-paste(l[[1]][1],l[[1]][2],l[[1]][3], sep='.')
  return(id1)
}
l_n<-grep('-',df_gp$ID)
df_gp$ID[l_n]<-unlist(lapply(df_gp$ID[l_n],trans_id))

library(DESeq2)
get_dge<-function(a1,a2,df_expr){
  phe<-df_gp[df_gp$group %in% c(a1,a2),]
  df_expr<-df_expr[,phe$ID]
  phe$group<-factor(phe$group)# before relevel
  phe$group<-relevel(phe$group,ref=a1) #ref is very important!
  dds <- DESeqDataSetFromMatrix(df_expr, phe, design= ~ group)
  dds<-DESeq(dds)
  res<-results(dds)
  res<-as.data.frame(res)
  return(res)
}
#only two pairs
res<-get_dge('Fm','WT',df_expr2)
save(res,file='res_deseq_Fm_WT.RData')

#extract results, abs(fc) is 1.2 and adj.p < 0.05
rm(list=ls())
load('./res_deseq_Fm_WT.RData')
sig_diff<-function(df,fc_cut){
  #fc_cut,such as 1.2 or 1.5
  df<-subset(df,!is.na(df$padj))
  df<-df[,c(2,6)] #columns of log2FoldChange and padj
  df$gene<-rownames(df)
  rownames(df)<-seq(1,dim(df)[1])
  df<-subset(df,df$padj<0.05&abs(df$log2FoldChange)>=fc_cut) #Note here!
  if(dim(df)[1]==0){
    df=data.frame(log2FoldChange=c(NA),padj=c(NA),gene=c(NA))}
  return(df)
}
#res_sig<-sig_diff(res,1) #two fold.
#write.table(res_sig,'fc1_sig.tbl',rownames=F,quote=F) #further reshape in shell

#reshape the file, from most significant to the least.
#including comparing with NC
#df_sig1<-read.table('fc12_sig_pairwise.tbl',header = T, stringsAsFactors = F)
#df_sig2<-read.table('../all_NC_ctrl/fc12_sig_all.tbl',header = T, stringsAsFactors = F)
#df_sig2$pair<-paste('NC',df_sig2$expr,sep='-')
#df_sig2<-df_sig2[,-5]
#df_sig_all<-rbind(df_sig1,df_sig2)
#library(dplyr)
#df_sig_all2<-arrange(df_sig_all,pair,padj,log2FoldChange)
#df_sig_all2$log2FoldChange<-format(df_sig_all2$log2FoldChange,digits = 4)
#df_sig_all2$padj<-format(df_sig_all2$padj,digits = 4,scientific = T)
#write.table(df_sig_all2,'fc12_sig_allpairwise_arrange.tbl')
