# A case study of powerwash simulator

Matti Vuorre, Nick Ballou, Andy Przybylski

This repository contains the data and code described in our manuscript "Title To Be Determined" (Vuorre, Ballou, & Przybylski).

## Data 

The code here pulls data from the PowerWash Simulator dataset at <https://osf.io/wpeh6/> (<https://psyarxiv.com/kyn7g>). See `Makefile`.

## Reproduce / contribute

The analysis code is written in R. `supplement.qmd` downloads and cleans the data, with other supplementary analyses. Main analyses are in `ms.qmd`. To run the files in the correct order, we use [GNU make](https://stat545.com/make-windows.html). (See `Makefile`.)

To contribute, open an issue or push changes on a new branch at <https://github.com/digital-wellbeing/pws-prepost> and send a pull request to the dev branch. Matti will review the issue / PR.
