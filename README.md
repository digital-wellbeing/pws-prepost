# A case study of powerwash simulator

Matti Vuorre, Nick Ballou, Andy Przybylski

This repository contains the data and code described in our manuscript "Title To Be Determined" (Vuorre, Ballou, & Przybylski).

## Data 

The code here pulls data from the PowerWash Simulator dataset at <https://osf.io/wpeh6/> (<https://psyarxiv.com/kyn7g>). See `Makefile`.

## Reproduce / contribute

The analysis code is written in R. `supplement.qmd` downloads and cleans the data, with other supplementary analyses. Main analyses are in `ms.qmd`. To run the files in the correct order, we use [GNU make](https://stat545.com/make-windows.html). (See `Makefile`.)

To contribute, open an issue or push changes on a new branch at <https://github.com/digital-wellbeing/pws-prepost> and send a pull request to the dev branch. Matti will review the issue / PR.

### Build using Docker
You can also build the project using Docker.

```bash
docker build \
    --build-arg R_VERSION=4.3.1 \
    --build-arg QUARTO_VERSION=1.3.450 \
    --build-arg RENV_VERSION=v1.0.3 \
    --build-arg CMDSTAN_VERSION=2.33.1 \
    -t pws-pre-post .
```

Then use the Docker image to render the Quarto project inside a new container.

```bash
docker run --rm \
    -v $(pwd)/wrangle.qmd:/home/wrangle.qmd \
    -v $(pwd)/analyze.qmd:/home/analyze.qmd \
    -v $(pwd)/continuous-time.qmd:/home/continuous-time.qmd \
    -v $(pwd)/R:/home/R \
    -v $(pwd)/data-raw/data.zip:/home/data-raw/data.zip \
    -v $(pwd)/data/demographics.csv:/home/data/demographics.csv \
    -v $(pwd)/data/study_prompt_answered.csv:/home/data/study_prompt_answered.csv \
    -v $(pwd)/_quarto.yml:/home/_quarto.yml \
    -v $(pwd)/bibliography.bib:/home/bibliography.bib \
    -v $(pwd)/docker/docs:/home/output \
    -v $(pwd)/docker/models:/home/models \
    -e N_CORES=4 \
    -e N_THREADS=2 \
    -e N_ITER=500 \
    -e N_SUBSET=100 \
    pws-pre-post 
```
Environment variables:
- `N_CORES` controls the number of CPU cores used by Stan. Default 1 if unset.
- `N_THREADS` controls number of threads to use in within-chain parallelization. Default 2 if unset.
- `N_ITER` sets the total number of iterations per chain. Default 2000 if unset.
- `N_SUBSET` _Optional_ development variable. Controls if the model should be fit to a subset of the data. An integer that specifies how many participants that will be randomly included. Includes all participants if unset.

Model objects are persistently stored in `./docker/models/`. Remove them for a clean run. 

Data files are bind-mounted into the container to avoid re-downloading the files every run. If this is not desired simply comment out those lines.

