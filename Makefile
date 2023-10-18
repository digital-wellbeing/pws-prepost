all: ms

ms: ms.Rmd
	Rscript -e 'rmarkdown::render("ms.Rmd", "all")'
