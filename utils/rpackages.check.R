#!Rscript
is.rmd=require("rmarkdown")
is.knitr=require("knitr")
is.dnacopy=require("DNAcopy")
if (is.rmd & is.knitr & is.dnacopy) {
	cat("Passed");
	#cat("Yeeh! Rmarkdown, knitr, and DNAcopy have been installed\n")
} else {
	cat("Failed");
}

