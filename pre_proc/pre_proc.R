#divided to catogries
df_expr<-read.csv('../expr/gene_count.csv',header = T, stringsAsFactors = F)
rownames(df_expr)<-df_expr$ID
df_expr<-df_expr[,-1]
l_filter<-c()
for (g in rownames(df_expr)){
  l_0<-length(which(df_expr[g,]==0))
  if(l_0==ncol(df_expr)){
    #print (df_expr[g,]) #checkpoint
    l_filter<-c(l_filter,g)}
}
df_expr2<-subset(df_expr,!rownames(df_expr) %in% l_filter)
write.table(df_expr2,'./gene_expr_filtered.tbl',quote = F)
df_expr<-read.table('./gene_expr_filtered.tbl',header = T, stringsAsFactors = F)
df_expr2<-round(df_expr)
df_map<-read.table('/mnt/fanc/genome_annot/trans2gene/mRatBN7.2.110_uniq.map',header = T, stringsAsFactors = F)

#catogries
#l_procode<-c('protein_coding')
#l_biotype<-names(table(df_map$biotype))
#l_ncRNA<-l_biotype[c(grep('RNA',l_biotype),18)]
#l_pseudo<-l_biotype[grep('pseudogene',l_biotype)]

#df1<-subset(df_expr2,rownames(df_expr2) %in% df_map$gene[df_map$biotype %in% l_procode])
#df2<-subset(df_expr2,rownames(df_expr2) %in% df_map$gene[df_map$biotype %in% l_ncRNA])
#df3<-subset(df_expr2,rownames(df_expr2) %in% df_map$gene[df_map$biotype %in% l_pseudo])

#save(df1,df2,df3,file='preproc_expr.RData')
save(df_expr2,file='preproc_expr.RData')
