a=read.table('data.txt',header=T,row.names=1,sep='\t')
b=a[which(!is.na(a[,1]*a[,2])),]
tmp=t.test(b[,2],b[,1],paired=T)
true_stat=tmp$statistic

c=c(b[,1],b[,2])
c=c[which(!is.na(c))]

END=100000
stat_list=c()

set.seed(12345)
i=1
while(i<=END){
  d1=sample(c,5)
  d2=sample(c,5) 
  this_stat=t.test(d2,d1,paired=T)$statistic
  stat_list=c(stat_list,this_stat)  
  if(i%%100==1){print(i)}
i=i+1}

stat_list=stat_list[which(!is.na(stat_list))]

PV=length(which(stat_list>true_stat))/length(stat_list)

save.image(file='data.RData')
#PV=0.0466828
load('data.RData')
pdf('permutation_test_sem.pdf',width=12,height=6)
#barplot(b[,1],b[,2])
par(mfrow=c(1,2))
M=c(mean(b[,1]),mean(b[,2]))
#SD=c(sd(b[,1]),sd(b[,2]))
SD=c(sd(b[,1])/sqrt(length(b[,1])), sd(b[,2])/sqrt(length(b[,2])) )

names(M)=c('primary','recurrence')
barCenters =barplot(M,ylim=c(0,40))
arrows(barCenters, M,
       barCenters, M+SD,angle=90,code=3)
points(x=c(rep(barCenters[1],5),rep(barCenters[2],5)),y=c(b[,1],b[,2]),pch=16,col='black',cex=1)




points(barCenters[2],(M+SD)[2]+1,pch=8,col='black')


plot(density(stat_list),main='',xlab='Statistic',xlim=c(-4,4))
abline(v=true_stat,lwd=1.5,col='red')
text(true_stat,0.2,'p.value=0.046',pos=4,col='red')
#text(0,0.1,'100,000 permutations',pos=1,col='black')
dev.off()




par(mfrow=c(1,2))
M=c(mean(b[,1]),mean(b[,2]))
#SD=c(sd(b[,1]),sd(b[,2]))
SD=c(sd(b[,1])/sqrt(length(b[,1])), sd(b[,2])/sqrt(length(b[,2])) )

names(M)=c('primary','recurrence')
barCenters =barplot(M,ylim=c(0,40))
arrows(barCenters, M,
       barCenters, M+SD,angle=90,code=3)
points(x=c(rep(barCenters[1],5),rep(barCenters[2],5)),y=c(b[,1],b[,2]),pch=16,col='black',cex=1)

names(M)=c('primary','recurrence')
barCenters =barplot(M,ylim=c(0,40))
arrows(barCenters, M,
       barCenters, M+SD,angle=90,code=3)

set.seed(123)
points(x=jitter(c(rep(barCenters[1],5),rep(barCenters[2],5))),y=c(b[,1],b[,2]),pch=16,col='black',cex=1)




