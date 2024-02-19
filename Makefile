all: pdf docx supp

pdf: ms.Rmd
	Rscript -e 'rmarkdown::render("$<", "papaja::apa6_pdf")'

docx: ms.Rmd
	Rscript -e 'rmarkdown::render("$<", "papaja::apa6_docx")'

supp:
	quarto render supplementary.qmd
