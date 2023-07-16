all: data

data: data-raw/data.zip

data-raw/data.zip:
	mkdir -p data-raw
	Rscript -e 'download.file("https://osf.io/download/j48qf/", destfile = "$@")'
	touch $@
	unzip data-raw/data.zip data/demographics.csv data/study_prompt_answered.csv
