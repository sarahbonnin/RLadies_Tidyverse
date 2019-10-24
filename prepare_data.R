# get data sets from https://www.bcn.cat/estadistica/catala/dades/tpob/pad/padro/a2019/nacio/nacio07.htm
# and https://www.bcn.cat/estadistica/catala/dades/tpob/pad/padro/a2019/nacio/nacio06.htm

# prep data
library(reshape2)

femi <- read.table("nacionalitat_barri_F.txt", sep="\t", header=T, as.is=T, row.names=NULL)
masc <- read.table("nacionalitat_barri_M.txt", sep="\t", header=T, as.is=T, row.names=NULL)

# remove "total" columns
femi <- femi[,-grep("Total|TOTAL|^X$|^X\\.[0-9]*$", colnames(femi))]
masc <- masc[,-grep("Total|TOTAL|^X$|^X\\.[0-9]*$", colnames(masc))]

# long format
femi_lg <- melt(femi, id.vars="Barris")
masc_lg <- melt(masc, id.vars="Barris")

# join masc and femi
all <- rbind(data.frame(masc_lg, genere="Home", stringsAsFactors=F), data.frame(femi_lg, genere="Dona", stringsAsFactors=F))
colnames(all) <- c("Barris", "Nacionalitat", "Total", "Genere")

all$Barris <- gsub("^[0-9]*\\.", "", all$Barris)

for(i in LETTERS){
all$Barris <- gsub(i, paste0(" ", i), all$Barris)
}

for(i in c("de", "del", "dels", "les")){
all$Barris <- gsub(paste0(i, " "), paste(" ", i, " "), all$Barris)
}

all$Barris <- gsub("^ *", "", all$Barris)
all$Barris <- gsub(" {2,3}", " ", all$Barris)


all$Barris <- gsub("Caterinaila", "Caterina i la", all$Barris)
all$Barris <- gsub("Fontdela", "Font de la", all$Barris)
all$Barris <- gsub("Maternitati", "Maternitat i", all$Barris)
all$Barris <- gsub("Tibidaboi", "Tibidabo i", all$Barris)
all$Barris <- gsub("Putxetiel", "Putxet i el", all$Barris)
all$Barris <- gsub("Vallcarcaiels", "Vallcarca i els", all$Barris)
all$Barris <- gsub("Grassoti", "Grassot i", all$Barris)
all$Barris <- gsub("Fontden", "Font d en", all$Barris)
all$Barris <- gsub("Valld", "Vall d", all$Barris)
all$Barris <- gsub("Vilapicinaila", "Vilapicina i la", all$Barris)
all$Barris <- gsub("Turódela", "Turó de la", all$Barris)
all$Barris <- gsub("Congrésiels", "Congrés i els", all$Barris)
all$Barris <- gsub("Besòsiel", "Besòs i el", all$Barris)
all$Barris <- gsub("Vernedaila", "Verneda i la", all$Barris)

all$Barris <- gsub("é|è", "e", all$Barris)
all$Barris <- gsub("í", "i", all$Barris)
all$Barris <- gsub("ò|ó", "o", all$Barris)
all$Barris <- gsub(",", "", all$Barris)
all$Barris <- gsub("á|à", "a", all$Barris)
all$Barris <- gsub("ç", "c", all$Barris)

# pending: same for countries!!

write.table(all, "data_poblacio_barcelona_barris.txt", row.names=F, col.names=T, sep="\t", quote=F)




