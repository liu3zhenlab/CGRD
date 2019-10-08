###################################################################################
### Sanzhen Liu
### Segmentation
### 9/13/2016
###################################################################################
### working directory:
setwd("/data1/home/liu3zhen/wheatBlast/16-SV/4-RDcnv/3-DNACopy.general/P3")
library("DNAcopy")

###################################################################################
### step0: variables
#==================================================================================
subj <- "B71"
qry <- "P3"
subjbc <- "../../2-bincounts/B71.bin.counts"
qrybc <- paste0("../../2-bincounts/", qry, ".bin.counts")
chrsizef <- "/data1/home/liu3zhen/wheatBlast/10-B71Ref1/B71Ref1.chrsize.txt"
libsizef <- "libsize.txt"
outfile <- paste0("1o-", qry, ".segmentation.txt")

###################################################################################
# step1: loading data
#==================================================================================
### ck
ck <- read.delim(subjbc, header = F)
colnames(ck) <- c("Chr", "Start", "End", "Order", "ck", "Bp", "Len", "Cov")
ck$Bin <- paste0(ck$Chr, "_", ck$Start, "-", ck$End)
ck$Pos <- round((ck$Start + ck$End) / 2, 0)

### exp
exp <- read.delim(qrybc, header = F)
colnames(exp) <- c("Chr", "Start", "End", "Order", "exp", "Bp", "Len", "Cov")
exp$Bin <- paste0(exp$Chr, "_", exp$Start, "-", exp$End)

### chr/ctg sizes:
chrsize <- read.delim(chrsizef)


### libsize
libsize <- read.delim(libsizef)
ck.libsize <- libsize[libsize$Sample == subj, "Reads"]
exp.libsize <- libsize[libsize$Sample == qry, "Reads"]
###################################################################################


###################################################################################
# step2: ck data exploration
#==================================================================================
b71.rd <- ck$ck
hist(ck$ck, nclass = 1000, xlim = c(0, 500))
low.bound <- quantile(b71.rd, 0.005)
up.bound <- quantile(b71.rd, 0.995)
nrow(ck)

cksub <- ck[ck$ck >= low.bound & ck$ck <= up.bound, c("Bin", "Chr", "Pos", "ck")]
head(cksub); nrow(cksub)


###################################################################################
# step2a: Preparation for segmentation
#==================================================================================
ck.exp <- merge(cksub, exp[, c("Bin", "exp")], by = "Bin")
ck.exp$log2FoldChange <- log2((ck.exp$exp + 1) / (ck.exp$ck + 1) / exp.libsize * ck.libsize)

### histogram
hist(ck.exp$log2FoldChange, nclass = 500, xlab = paste0("Log2(", qry, ":", subj, ")"),
     ylab = "Number of Bins", main = paste0(qry, " vs. ", subj))


###################################################################################
# step2b: segmentation
#==================================================================================
log2fc <- ck.exp[,c("Chr", "Pos", "log2FoldChange")]

# segmentation:
expCNA <-CNA(log2fc$log2FoldChange, log2fc$Chr, log2fc$Pos, data.type ="logratio", sampleid = "exp")
exp.CNA.smoothed <- smooth.CNA(expCNA, smooth.region = 10, outlier.SD.scale = 4, smooth.SD.scale = 2, trim = 0.01)

# core step for the segmentation:
exp.CNA.segment3 <- segment(exp.CNA.smoothed, alpha=0.005, nperm=10000, p.method="perm", eta=0.005, min.width=3, undo.splits = "sdundo", undo.SD = 3)

# output:
exp.seg <- exp.CNA.segment3$output
###################################################################################

###################################################################################
# step3: adjust coordinates
#==================================================================================
### refine the segment starting and ending positions:
exp.seg2 <- exp.seg
exp.seg$Order <- 1:nrow(exp.seg) 
start.pos <- merge(exp.seg[, c("chrom", "loc.start", "Order")], ck[, c("Chr", "Start", "Pos")],
                   by.x = c("chrom", "loc.start"), by.y = c("Chr", "Pos"))
start.pos <- start.pos[order(start.pos$Order), ]
head(start.pos)
exp.seg2$loc.start <- start.pos$Start
end.pos <- merge(exp.seg[, c("chrom", "loc.end", "Order")], 
                 ck[, c("Chr", "End", "Pos")],
                 by.x = c("chrom", "loc.end"), by.y = c("Chr", "Pos"))
end.pos <- end.pos[order(end.pos$Order), ]
exp.seg2$loc.end <- end.pos$End
head(exp.seg2)

### output:
write.table(exp.seg2[, -c(1, 7)], file=outfile, row.names=F, col.names=F, quote=F, sep="\t")

