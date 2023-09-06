all: ms

ms: pdf docx html

pdf: ms.qmd
	quarto render $< -t pdf

docx: ms.qmd
	quarto render $< -t docx

html: ms.qmd
	quarto render $< -t html
