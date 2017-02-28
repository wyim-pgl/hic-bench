#!/usr/bin/env Rscript

usage = "\
Rscript chipseq-venn-diagramr [OPTIONS] PEAK-FILE(s)
"
suppressPackageStartupMessages(library(optparse))
option_list <- list(
  make_option(c("-o","--outputdir"),default="./", help="output directory."),
  make_option(c("-g","--genome"),default="./", help="annotation genome")
)
arguments = parse_args(args=commandArgs(trailingOnly=T), OptionParser(usage=usage,option_list=option_list), positional_arguments=c(0,Inf))
opt = arguments$options
inputs = arguments$args
if (length(inputs)<2||length(inputs)>5) { write(paste("USAGE: ",usage," #### Number of peak files supported is 2 to 5.\n",sep=''),stderr()); quit(save='no') }

suppressPackageStartupMessages(library(ChIPseeker))
suppressPackageStartupMessages(library(tools))

files=list()
for (i in 1:length(inputs)){
  files=append(files, list(inputs[i]))
  names(files)[i]=basename(dirname(inputs[i]))
}

if(!dir.exists(opt$outputdir)){dir.create(opt$outputdir)}

peak.Sets <- lapply(files, readPeakFile)


tryCatch({
  pdf(file = paste0(opt$outputdir,"/venn-diagram.pdf"), pointsize=6 )
  vennplot(peak.Sets)
  dev.off()
 },
 error=function(e){
  dev.off()
  cat(conditionMessage(e),"\n")
 }
)
