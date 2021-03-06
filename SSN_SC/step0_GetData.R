library(Seurat)
library(dplyr)
library(Matrix)

load("./images/Seurat_EXP_cluster.Robj")

vargene_row=which(row.names(EXP_cluster@data) %in% EXP_cluster@var.genes)
OUT=as.matrix(EXP_cluster@data[vargene_row,])
write.table(file='var_gene_data.txt',OUT,sep='\t',quote=F,row.names=T,col.names=T)


