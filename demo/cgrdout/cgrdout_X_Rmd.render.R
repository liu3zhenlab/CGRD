library(rmarkdown)
library(knitr)

render('/homes/liu3zhen/scripts2/CGRD/utils/rdseg.Rmd',
  params = list(
    version="0.3.6",
    subj="ref",
    qry="qry",
    bc="cgrdout/cgrdout_3b_bin.counts",
    libsizef="cgrdout/libsize.txt",
    adj0="0",
    chrsizef="cgrdout/chrsize.txt",
    outfile="cgrdout_qry_ref.segments.txt",
    groupval="-5 -0.2 0.2 0.6",
    pdfWidth="7",
    pdfHeight="7.5",
    chr2plot="all",
    newgrouplab="_TMPNEWGROUP"),
  knit_root_dir=getwd(),
  output_dir=getwd(),
  output_format="html_document",
  output_file="cgrdout_qry_ref.report.html")
