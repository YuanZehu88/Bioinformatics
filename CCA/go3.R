
source('https://raw.githubusercontent.com/jumphone/Bioinformatics/master/CCA/BEER.R')
source('https://raw.githubusercontent.com/jumphone/scRef/master/scRef.R')

D1=readRDS('CT.RDS')
D2=readRDS('MS.RDS')


beerout=BEER(D1, D2, CNUM=100, PCNUM=50, CPU=1)


source('https://raw.githubusercontent.com/jumphone/BEER/master/BEER.R')
source('https://raw.githubusercontent.com/jumphone/scRef/master/scRef.R')

D1=readRDS('CT.RDS')
D2=readRDS('MS.RDS')
beerout=BEER(D1, D2, CNUM=100, PCNUM=50, CPU=1)




saveRDS(beerout,file='beerout.RDS')


beerout=readRDS('beerout.RDS')

pbmc=beerout$seurat

PCUSE=which(beerout$cor>0.7 & p.adjust(beerout$pv,method='fdr')<0.05) 
pbmc <- RunUMAP(object = pbmc, reduction.use='pca',dims.use = PCUSE, do.fast = TRUE, check_duplicates=FALSE)
DimPlot(pbmc,reduction.use='umap',group.by='batch',pt.size=0.1)
DimPlot(pbmc,reduction.use='umap',group.by='map',pt.size=0.1)



PCUSE=1:50
pcpbmc <- RunUMAP(object = pbmc, reduction.use='pca',dims.use = PCUSE, do.fast = TRUE, check_duplicates=FALSE)
DimPlot(pcpbmc,reduction.use='umap',group.by='batch',pt.size=0.1)



pcpbmc <- RunUMAP(object = pbmc, reduction.use='pca',dims.use = PCUSE, do.fast = TRUE, check_duplicates=FALSE)
DimPlot(pcpbmc,reduction.use='umap',group.by='condition',pt.size=0.1)
DimPlot(pcpbmc,reduction.use='umap',group.by='map',pt.size=0.1)



pdf('ALL.pdf',width=20,height=17)
DimPlot(pbmc,reduction.use='umap',group.by='condition',pt.size=0.1)
DimPlot(pcpbmc,reduction.use='umap',group.by='condition',pt.size=0.1)
DimPlot(pbmc,reduction.use='umap',group.by='map',pt.size=0.1)
DimPlot(pcpbmc,reduction.use='umap',group.by='map',pt.size=0.1)
dev.off()



##################################





load('TSNE.RData')
library('Seurat')
source('scRef.R')
ori_label=read.table('Zeisel_exp_sc_mat_cluster_original.txt',header=T,sep='\t')
pbmc@meta.data$ori=ori_label[,2]


USE=which(pbmc@meta.data$ori=='astrocytes_ependymal')

COL=c()
i=1
while(i <=length(pbmc@ident)){
    this_col=which(colnames(pbmc@raw.data)==names(pbmc@ident)[i])
    COL=c(COL,this_col)
    i=i+1
    } 

ref_tag=cbind(names(pbmc@ident), as.character(pbmc@meta.data$ori))    
exp_ref_mat=as.matrix(pbmc@raw.data)[,COL]
exp_sc_mat= exp_ref_mat[,USE]

D1=exp_ref_mat


EXP=readRDS('GSE75330.RDS')
D2=as.matrix(EXP@raw.data)


source('https://raw.githubusercontent.com/jumphone/Bioinformatics/master/CCA/BEER.R')
source('https://raw.githubusercontent.com/jumphone/scRef/master/scRef.R')


#bastout=BAST(D1, D2, CNUM=10, PCNUM=50, FDR=1, COR=0, CPU=4, print_step=10)
beerout=BEER(D1, D2, CNUM=10, PCNUM=50, CPU=1, print_step=10)


pbmc=beerout$seurat


LABEL=c(as.character(ori_label[,2]), EXP@meta.data$label )
pbmc@meta.data$label=LABEL

PCUSE=which(beerout$cor>0.8 & p.adjust(beerout$pv,method='fdr')<0.05) 
pbmc <- RunUMAP(object = pbmc, reduction.use='adjpca',dims.use = PCUSE, do.fast = TRUE, check_duplicates=FALSE)
DimPlot(pbmc,reduction.use='umap',group.by='condition',pt.size=0.1)
DimPlot(pbmc,reduction.use='umap',group.by='label',pt.size=0.1, do.label=T)
DimPlot(pbmc,reduction.use='umap',group.by='map',pt.size=0.1)

pcpbmc <- RunUMAP(object = pbmc, reduction.use='pca',dims.use = PCUSE, do.fast = TRUE, check_duplicates=FALSE)
DimPlot(pcpbmc,reduction.use='umap',group.by='condition',pt.size=0.1)
DimPlot(pcpbmc,reduction.use='umap',group.by='map',pt.size=0.1)
DimPlot(pcpbmc,reduction.use='umap',group.by='label',pt.size=0.1, do.label=T)

PCUSE=1:50
pcpbmc <- RunUMAP(object = pbmc, reduction.use='pca',dims.use = PCUSE, do.fast = TRUE, check_duplicates=FALSE)
DimPlot(pcpbmc,reduction.use='umap',group.by='condition',pt.size=0.1)
DimPlot(pcpbmc,reduction.use='umap',group.by='label',pt.size=0.1, do.label=T)



##################################


source('https://raw.githubusercontent.com/jumphone/Bioinformatics/master/CCA/BEER.R')
source('https://raw.githubusercontent.com/jumphone/scRef/master/scRef.R')
#D1=read.table('GSE70630_OG_processed_data_v2_MGH53.txt',sep='\t',row.names=1,header=T)
#D2=read.table('GSE70630_OG_processed_data_v2_MGH54.txt',sep='\t',row.names=1,header=T)

D1=read.table('MGH53_mat.txt',sep='\t',row.names=1,header=T)
D2=read.table('MGH54_mat.txt',sep='\t',row.names=1,header=T)


beerout=BEER(D1, D2, CNUM=10, PCNUM=50, CPU=1, print_step=10)

plot(beerout$cor,-log(beerout$fdr))

pbmc=beerout$seurat


#LABEL=c(as.character(ori_label[,2]), EXP@meta.data$label )
#pbmc@meta.data$label=LABEL

PCUSE=which(beerout$cor>0.7 & p.adjust(beerout$pv,method='fdr')<0.05) 
#PCUSE=which(beerout$fdr <0.1)#which(beerout$fdr < 0.15)#which(beerout$fdr < 0.1469528 & beerout$cor>0.9) #which(beerout$cor>0.9 & p.adjust(beerout$pv,method='fdr')<0.05) 
pbmc <- RunUMAP(object = pbmc, reduction.use='adjpca',dims.use = PCUSE, do.fast = TRUE, check_duplicates=FALSE)
DimPlot(pbmc,reduction.use='umap',group.by='condition',pt.size=0.1)
#DimPlot(pbmc,reduction.use='umap',group.by='label',pt.size=0.1, do.label=T)
DimPlot(pbmc,reduction.use='umap',group.by='map',pt.size=0.1)

pcpbmc <- RunUMAP(object = pbmc, reduction.use='pca',dims.use = PCUSE, do.fast = TRUE, check_duplicates=FALSE)
DimPlot(pcpbmc,reduction.use='umap',group.by='condition',pt.size=0.1)
DimPlot(pcpbmc,reduction.use='umap',group.by='map',pt.size=0.1)
#DimPlot(pcpbmc,reduction.use='umap',group.by='label',pt.size=0.1, do.label=T)

PCUSE=1:50
pcpbmc <- RunUMAP(object = pbmc, reduction.use='pca',dims.use = PCUSE, do.fast = TRUE, check_duplicates=FALSE)
DimPlot(pcpbmc,reduction.use='umap',group.by='condition',pt.size=0.1)
#DimPlot(pcpbmc,reduction.use='umap',group.by='label',pt.size=0.1, do.label=T)


























load('TSNE.RData')
library('Seurat')
source('scRef.R')
ori_label=read.table('Zeisel_exp_sc_mat_cluster_original.txt',header=T,sep='\t')
pbmc@meta.data$ori=ori_label[,2]


USE=which(pbmc@meta.data$ori=='astrocytes_ependymal')

COL=c()
i=1
while(i <=length(pbmc@ident)){
    this_col=which(colnames(pbmc@raw.data)==names(pbmc@ident)[i])
    COL=c(COL,this_col)
    i=i+1
    } 

ref_tag=cbind(names(pbmc@ident), as.character(pbmc@meta.data$ori))    
exp_ref_mat=as.matrix(pbmc@raw.data)[,COL]
exp_sc_mat= exp_ref_mat[,USE]

getRanGene <- function(X){
    POS = which(X >0 )
    N=length(POS)/2
    KEEP = sample(x=POS, size=N )
    NEG = POS[which(!POS %in% KEEP)]
    X[NEG]=0
    return(X)
    }

set.seed(123)
sim_exp_sc_mat = apply(exp_sc_mat,2, getRanGene)


D1=sim_exp_sc_mat
D2=exp_ref_mat
colnames(D1)=paste0('sim_',colnames(D1))


source('https://raw.githubusercontent.com/jumphone/Bioinformatics/master/CCA/BEER.R')
source('https://raw.githubusercontent.com/jumphone/scRef/master/scRef.R')


#bastout=BAST(D1, D2, CNUM=10, PCNUM=50, FDR=1, COR=0, CPU=4, print_step=10)
beerout=BEER(D1, D2, CNUM=10, PCNUM=50, CPU=4, print_step=10)



pbmc=beerout$seurat

PCUSE=which(beerout$cor>0.6 & p.adjust(beerout$pv,method='fdr')<0.05) 
pbmc <- RunUMAP(object = pbmc, reduction.use='adjpca',dims.use = PCUSE, do.fast = TRUE, check_duplicates=FALSE)
DimPlot(pbmc,reduction.use='umap',group.by='condition',pt.size=0.1)
DimPlot(pbmc,reduction.use='umap',group.by='map',pt.size=0.1)

pcpbmc <- RunUMAP(object = pbmc, reduction.use='pca',dims.use = PCUSE, do.fast = TRUE, check_duplicates=FALSE)
DimPlot(pcpbmc,reduction.use='umap',group.by='condition',pt.size=0.1)
DimPlot(pcpbmc,reduction.use='umap',group.by='map',pt.size=0.1)

PCUSE=1:50
pcpbmc <- RunUMAP(object = pbmc, reduction.use='pca',dims.use = PCUSE, do.fast = TRUE, check_duplicates=FALSE)
DimPlot(pcpbmc,reduction.use='umap',group.by='condition',pt.size=0.1)




















DimPlot(bastout$seurat,reduction.use='umap',group.by='condition',pt.size=0.1)


LABEL=c(rep('SIM_astrocytes_ependymal',ncol(D1)),as.character(ori_label[,2]))
bastout$seurat@meta.data$lab=LABEL
DimPlot(bastout$seurat,reduction.use='umap',group.by='lab',pt.size=0.1)

DimPlot(bastout$seurat,reduction.use='umap',group.by='condition',pt.size=0.1)





























D1X=.data2one(D1)
D2X=.data2one(D2)


G1=.getGroup(D1X,'D1',CNUM=10)
G2=.getGroup(D2X,'D2',CNUM=10)

VP_OUT=.getValidpair(D1, G1, D2, G2, CPU=4, method='kendall', print_step=10)
VP=VP_OUT$vp



colnames(D1)=paste0('sim_',colnames(D1))

EXP=.simple_combine(D1,D2)$combine
GROUP=c(G1,G2)
CONDITION=c(rep('D1',ncol(D1)),rep('D2',ncol(D2)))

library(Seurat)
pbmc=CreateSeuratObject(raw.data = EXP, min.cells = 0, min.genes = 0, project = "ALL")
pbmc@meta.data$group=GROUP
pbmc@meta.data$condition=CONDITION

MAP=rep('NA',length(GROUP))
MAP[which(GROUP %in% VP[,1])]='D1'
MAP[which(GROUP %in% VP[,2])]='D2'
pbmc@meta.data$map=MAP

pbmc <- NormalizeData(object = pbmc, normalization.method = "LogNormalize", scale.factor = 10000)
pbmc <- FindVariableGenes(object = pbmc, do.plot=F,mean.function = ExpMean, dispersion.function = LogVMR, x.low.cutoff = 0.0125, x.high.cutoff = 3, y.cutoff = 0.5)
length(x = pbmc@var.genes)
pbmc <- ScaleData(object = pbmc, genes.use=pbmc@var.genes, vars.to.regress = c("nUMI"))


PCNUM=50
pbmc <- RunPCA(object = pbmc, pcs.compute=PCNUM,pc.genes = pbmc@var.genes, do.print =F)


DR=pbmc@dr$pca@cell.embeddings
B1index=which(CONDITION=='D1')
B2index=which(CONDITION=='D2')


OUT=.dr2adr(DR, B1index, B2index, GROUP, VP)


par(mfrow=c(1,2))
plot(OUT$cor,pch=16)
plot(-log(OUT$pv),pch=16)


pbmc@dr$oldpca=pbmc@dr$pca
pbmc@dr$pca@cell.embeddings=OUT$adr


PCUSE=which(p.adjust(OUT$pv,method='fdr')<0.05 & OUT$cor>0.8)
pbmc <- RunUMAP(object = pbmc, reduction.use='pca',dims.use = PCUSE)


LABEL=c(rep('SIM_astrocytes_ependymal',ncol(D1)),as.character(ori_label[,2]))
pbmc@meta.data$lab=LABEL

pdf('our_MAP.pdf',width=10,height=7)
DimPlot(object =pbmc, reduction.use = "umap", group.by = "map",  pt.size = 0.1, do.return = TRUE)
DimPlot(object =pbmc, reduction.use = "umap", group.by = "condition",  pt.size = 0.1, do.return = TRUE)
DimPlot(object =pbmc, reduction.use = "umap", group.by = "lab",  pt.size = 0.1, do.return = TRUE)
DimPlot(object =pbmc, reduction.use = "umap",  pt.size = 0.1, do.return = TRUE)
dev.off()

##############
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("scran", version = "3.8")
library(scran)

gene.counts1=D1
sce1 <- SingleCellExperiment(list(counts=gene.counts1))
sce1 <- normalize(sce1)

gene.counts2=D2
sce2 <- SingleCellExperiment(list(counts=gene.counts2))
sce2 <- normalize(sce2)

b1 <- sce1
b2 <- sce2
out <- fastMNN(b1, b2)
dim(out$corrected)

saveRDS(out,file='MNNout.RDS')

source('https://raw.githubusercontent.com/jumphone/Bioinformatics/master/CCA/BAST.R')

colnames(D1)=paste0('sim_',colnames(D1))

bastout=BAST(D1,D2,CNUM=10,PCNUM=50, FDR=0.05, COR=0.6)

saveRDS(bastout,file='BASTout.RDS')

TSNEPlot(bastout$seurat,group.by='condition')




pbmc=bastout$seurat
pbmc@dr$pca@cell.embeddings=out$corrected
rownames(pbmc@dr$pca@cell.embeddings)=rownames(pbmc@dr$oldpca@cell.embeddings)
colnames(pbmc@dr$pca@cell.embeddings)=colnames(pbmc@dr$oldpca@cell.embeddings)
PCUSE=1:50
pbmc <- RunUMAP(object = pbmc, reduction.use='pca',dims.use = PCUSE)

TSNEPlot(pbmc,group.by='condition')
DimPlot(object =pbmc, reduction.use = "umap", group.by = "condition",  pt.size = 0.1, do.return = TRUE)
LABEL=c(rep('SIM_astrocytes_ependymal',ncol(D1)),as.character(ori_label[,2]))
pbmc@meta.data$lab=LABEL
DimPlot(object =pbmc, reduction.use = "umap", group.by = "condition",  pt.size = 0.1, do.return = TRUE)
DimPlot(object =pbmc, reduction.use = "umap", group.by = "lab",  pt.size = 0.1, do.return = TRUE)





#PCUSE=1:50
#bastout$seurat <- RunUMAP(object = bastout$seurat, reduction.use='pca',dims.use = PCUSE)

bastout$seurat@meta.data$lab=LABEL
DimPlot(object =bastout$seurat, reduction.use = "umap", group.by = "lab",  pt.size = 0.1, do.return = TRUE)
DimPlot(object =bastout$seurat, reduction.use = "umap", group.by = "condition",  pt.size = 0.1, do.return = TRUE)



