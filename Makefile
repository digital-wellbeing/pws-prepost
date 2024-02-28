all: renv pdf docx supp

renv: renv.lock
	Rscript -e 'renv::restore()'

pdf: ms.Rmd
	Rscript -e 'rmarkdown::render("$<", "papaja::apa6_pdf")'

docx: ms.Rmd
	Rscript -e 'rmarkdown::render("$<", "papaja::apa6_docx")'

supp:
	quarto render supplementary.qmd
