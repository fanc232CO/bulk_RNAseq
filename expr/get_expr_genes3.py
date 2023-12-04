#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec  7 11:30:47 2020
@author: fanc232
combine salon expression
"""
import pandas as pd
from fnmatch import fnmatchcase as match

list_sample=pd.read_csv('./sampl.list',header=None)
list_sample=list(list_sample.iloc[:,0])
#list_fn=pd.read_csv('./fn_TPM.list',header=None) #quant or TPM?
list_fn=pd.read_csv('./fn_count.list',header=None)
list_fn=list(list_fn.iloc[:,0])
#l_grp=['1423']*4+['1928']*4+['NC']*4 #made df_group.csv manually this time.
#df_grp=pd.DataFrame({'ID':list_sample,'group':l_grp})
#df_grp.to_csv('./df_group.csv',index=False)

def get_expr(sn):
    #sn for sample name
    #grp for group
    fn=[x for x in list_fn if match(x,"*"+sn+"*")][0]
    df=pd.read_csv(fn,header=0,sep=' ',index_col=0,names=['ID',sn])
    return (df)

sn=list_sample[0]
df_expr=get_expr(sn)

for ic in range(1,len(list_sample)):
    sn=list_sample[ic]
    df=get_expr(sn)
    df_expr1=pd.merge(df_expr,df,how='outer',on='ID')
    df_expr=df_expr1
#df_expr.to_csv('gene_TPM.csv')
df_expr.to_csv('gene_count.csv')
