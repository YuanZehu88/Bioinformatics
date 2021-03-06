library(Seurat)
library(dplyr)

pbmc.data <- read.table('ALL.txt',sep='\t',check.name=F,row.names=1,header=T)
pbmc <- CreateSeuratObject(raw.data = pbmc.data, min.cells = 3, min.genes = 200, project = "Natalie")
#save(pbmc,file='ALL_raw.RObj')

mito.genes <- grep(pattern = "^mt-", x = rownames(x = pbmc@data), value = TRUE)
percent.mito <- Matrix::colSums(pbmc@raw.data[mito.genes, ])/Matrix::colSums(pbmc@raw.data)
pbmc <- AddMetaData(object = pbmc, metadata = percent.mito, col.name = "percent.mito")
pbmc <- AddMetaData(object = pbmc, metadata = pbmc@ident, col.name = "batch")

VlnPlot(object = pbmc, features.plot = c("nGene", "nUMI", "percent.mito"), nCol = 3)
pbmc=FilterCells(object = pbmc, subset.names = c("nGene", "percent.mito"), low.thresholds = c(200, -Inf), high.thresholds = c(3000, 0.1))
pbmc <- NormalizeData(object = pbmc, normalization.method = "LogNormalize", scale.factor = 10000)

pbmc <- FindVariableGenes(object = pbmc, do.plot = F, mean.function = ExpMean, dispersion.function = LogVMR, x.low.cutoff =0, y.cutoff = 0.5)
length(x=pbmc@var.genes) #4388
pbmc = ScaleData(object = pbmc,vars.to.regress = c("percent.mito", "nUMI", "batch"), genes.use=pbmc@var.genes)

stim=rep('case',length(pbmc@meta.data$batch))
stim[which(pbmc@meta.data$batch=='WT4to8')]='wt'
stim[which(pbmc@meta.data$batch=='WT6')]='wt'
pbmc@meta.data$stim=stim

g1=rownames(pbmc@meta.data)[which(pbmc@meta.data$stim=='case')]
g2=rownames(pbmc@meta.data)[which(pbmc@meta.data$stim=='wt')]

NUM=40
pbmc <- RunCCA(pbmc, group1=g1, group2=g2,  genes.use = pbmc@var.genes, num.cc = NUM)

DimPlot(object = pbmc, reduction.use = "cca", group.by = "stim",  pt.size = 0.5, do.return = F)

DIM=1:35
#DIM=1:2
pbmc <- AlignSubspace(pbmc , reduction.type = "cca", grouping.var = "stim",  dims.align = DIM, num.possible.genes=2000, num.genes=5)
pdf('tmp.pdf')
DimPlot(object = pbmc, reduction.use = "cca.aligned", group.by = "stim",  pt.size = 0.5, do.return = F)
dev.off()
#save(pbmc,file='ALL_cca.RObj')

DimPlot(object = pbmc, reduction.use = "cca.aligned", group.by = "stim",  pt.size = 0.5, do.return = F,dim.1=6,dim.2=7)
DimPlot(object = pbmc, reduction.use = "cca.aligned", group.by = "stim",  pt.size = 0.5, do.return = F,dim.1=8,dim.2=9)

TSNE_DIM=1:9
pbmc  <- RunTSNE(pbmc , reduction.use = "cca.aligned", dims.use = TSNE_DIM, do.fast = T)


pdf('TSNE.pdf',width=15,height=10)
TSNEPlot(object = pbmc, group.by = "stim", pt.size=0.5)
dev.off()
#save(pbmc,file='ALL_tSNE.RObj')


