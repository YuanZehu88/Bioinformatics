


setwd('/users/zha8dh/tianlab/HFZ')
source('./BEER.R')


pbmc=readRDS('./pbmc.RDS')

VEC=pbmc@reductions$umap@cell.embeddings

# Here, we use K-means to do the clustering
#N=50
#set.seed(1)
#K=kmeans(VEC,centers=N)

#CLUST=K$cluster
#pbmc@meta.data$clust=as.character(CLUST)

#saveRDS(pbmc@meta.data, file='META.RDS')
#pdf('~/Downloads/HFZ5.CLUST.CHECK.pdf',width=10,height=10)
#DimPlot(pbmc, reduction.use='umap', group.by='clust', pt.size=0.5,label=TRUE)
#dev.off()




pbmc@meta.data=readRDS('META.RDS')

pbmc@meta.data$level1=rep('Placenta',ncol(pbmc))
pbmc@meta.data$level1[which(pbmc@meta.data$batch %in% names(table(pbmc@meta.data$batch))[1:9])]='Decidua'

pdf('~/Downloads/HFZ3.two.pdf',width=10,height=10)
DimPlot(pbmc, group.by='level1')
dev.off()

pdf('~/Downloads/HFZ3.two.small.pdf',width=7,height=7)
DimPlot(pbmc, group.by='level1',pt.size=0.1,label=T)+NoLegend()
dev.off()

pdf('~/Downloads/HFZ3.EXP.pdf',width=10,height=5)
FeaturePlot(pbmc, features=c('PTPRC','CLDN5'))
FeaturePlot(pbmc, features=c('FN1','CDH1'))
dev.off()

pbmc.markers=readRDS(file='pbmc.markers.RDS')

#EXP_CLUST=.generate_mean(pbmc@assays$RNA@data,pbmc@meta.data$clust)
#######################################
N=50
set.seed(1)
K=kmeans(VEC,centers=N)

CLUST=K$cluster
pbmc@meta.data$clust=as.character(CLUST)

#saveRDS(pbmc@meta.data, file='META_300.RDS')

#pdf('~/Downloads/HFZ5.CLUST.300.pdf',width=20,height=20)
#DimPlot(pbmc, reduction.use='umap', group.by='clust', pt.size=0.5,label=TRUE) + NoLegend()
#dev.off()

EXP_CLUST=.generate_mean(pbmc@assays$RNA@data,pbmc@meta.data$clust)
VEC_CLUST=.generate_mean(t(pbmc@reductions$umap@cell.embeddings), pbmc@meta.data$clust)

saveRDS(EXP_CLUST, file='./EXP_CLUST.RDS')
saveRDS(VEC_CLUST, file='./VEC_CLUST.RDS')


saveRDS(EXP_CLUST, file='~/Downloads/EXP_CLUST.RDS')
saveRDS(VEC_CLUST, file='~/Downloads/VEC_CLUST.RDS')


##########################
pbmc.markers=readRDS(file='pbmc.markers.RDS')
.writeTable(pbmc.markers,PATH='~/Downloads/Markers.txt')
saveRDS(pbmc.markers,'~/Downloads/pbmc.markers.RDS')

library(dplyr)
top10 <- pbmc.markers %>% group_by(cluster) %>% top_n(n = 10, wt = avg_logFC)
top10=as.matrix(top10)
rownames(top10)=c(1:nrow(top10))
.writeTable(top10,PATH='~/Downloads/top10.txt')


pbmc=readRDS('./pbmc.RDS')
top10 <- pbmc.markers %>% group_by(cluster) %>% top_n(n = 10, wt = avg_logFC)

pbmc@meta.data=readRDS(file='META.RDS')
Idents(pbmc)=pbmc@meta.data$clust

pdf('~/Downloads/HFZ6.HEAT.pdf',width=30,height=30)
DoHeatmap(pbmc, features = top10$gene) + NoLegend()
dev.off()



#####################

#####################

#####################






##Local
setwd('F:/Hongfangzi')

library(Seurat)
library(dplyr)

DATA=readRDS('./EXP_CLUST.RDS')
VEC=readRDS('./VEC_CLUST.RDS')

pbmc <- CreateSeuratObject(counts = DATA, project = "pbmc3k", min.cells = 0, min.features = 0)

pbmc <- NormalizeData(pbmc, normalization.method = "LogNormalize", scale.factor = 10000)


all.genes <- rownames(pbmc)
pbmc <- ScaleData(pbmc, features = all.genes)

pbmc <- FindVariableFeatures(pbmc, selection.method = "vst", nfeatures = 2000)
pbmc <- RunPCA(pbmc, features = VariableFeatures(object = pbmc)，npcs=10)
pbmc <- RunUMAP(pbmc, dims = 1:10)

pbmc@reductions$umap@cell.embeddings[,1]=VEC[1,]
pbmc@reductions$umap@cell.embeddings[,2]=VEC[2,]

DimPlot(pbmc,pt.size=3)

FeaturePlot(pbmc,features=c('PTPRC',''),pt.size=3)






pbmc.markers=readRDS(file='pbmc.markers.RDS')

top10 <- pbmc.markers %>% group_by(cluster) %>% top_n(n = 10, wt = avg_logFC)

DATA=DATA[which(rownames(DATA) %in% top10$gene),]
SDATA=t(apply(DATA,1,scale))
rownames(SDATA)=rownames(DATA)
colnames(SDATA)=colnames(DATA)


library('ComplexHeatmap')
library('circlize')
library('seriation')


mat=SDATA
#METHOD='GW'
METHOD='ARSA'
o1 = get_order(seriate(dist(mat), method = METHOD))
#o2 = order(apply(log(mat+1,10),2,sum))#get_order(seriate(dist(t(mat)), method = METHOD))
#o1= c(3,4,)
o2 = get_order(seriate(dist(t(mat)), method = METHOD))

o.mat=mat[o1,o2]
col_fun =colorRamp2(c(0,1,2 ), c('royalblue3','yellow','red'))


pdf('HEAT.pdf',width=20,height=50)
Heatmap(o.mat,row_title='',name="%",cluster_rows=FALSE,cluster_columns=FALSE,
	show_column_dend = FALSE, show_row_dend = FALSE, 
	show_column_names=TRUE, show_row_names=TRUE,
	col=col_fun, border = FALSE
	)
dev.off()






library('ComplexHeatmap')
library('circlize')
library('seriation')


COR=cor(DATA)


mat=COR
#METHOD='GW'
METHOD='ARSA'
o1 = get_order(seriate(dist(mat), method = METHOD))
#o2 = order(apply(log(mat+1,10),2,sum))#get_order(seriate(dist(t(mat)), method = METHOD))
#o1= c(3,4,)
o2 = get_order(seriate(dist(t(mat)), method = METHOD))

o.mat=mat[o1,o2]
col_fun =colorRamp2(c(0.5,0.8,1 ), c('royalblue3','yellow','red'))


pdf('HEAT_COR.pdf',width=15,height=15)
Heatmap(o.mat,row_title='',name="%",cluster_rows=FALSE,cluster_columns=FALSE,
	show_column_dend = FALSE, show_row_dend = FALSE, 
	show_column_names=TRUE, show_row_names=TRUE,
	col=col_fun, border = FALSE
	)
dev.off()



