all: wrangle analyze

analyze: analyze.qmd wrangle.qmd
	quarto render $<

wrangle: wrangle.qmd
	quarto render $<

clean:
	rm -rf *_cache *_files *.pdf *.html *.docx
