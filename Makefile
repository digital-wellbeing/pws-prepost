all: supplement.html ms.pdf

supplement.html: supplement.qmd
	quarto render $<

ms.pdf: ms.qmd supplement.html
	quarto render $<
