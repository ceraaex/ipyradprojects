output_dir<-c("/work/cerraex/ipyrad_project/K_best")
tbl = read.table(output_dir,pattern="\\.Q",full.names=TRUE)
indTable = read.table(output_dir,pattern="\\.ind",full.names=TRUE,
               col.names = c("Sample", "Sex", "Pop"))

# mergedAdmixtureTable = cbind(tbl, indTable)
# mergedAdmWithPopGroups = merge(mergedAdmixtureTable, popGroups, by="Pop")
# ordered = mergedAdmWithPopGroups[order(mergedAdmWithPopGroups$PopGroup),]
# barplot(t(as.matrix(subset(ordered, select=V1:V6))), col=rainbow(6), border=NA)