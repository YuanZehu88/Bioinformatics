#
#http://homer.ucsd.edu/homer/

perl configureHomer.pl -install homer
perl /Users/zha8dh/Desktop/CCHMC_Project/LIJUN/Motif_20190312/.//configureHomer.pl -install mm10

./bin/findMotifsGenome.pl Lijun.txt.bed.bed mm10 OUTPUT -size 200


