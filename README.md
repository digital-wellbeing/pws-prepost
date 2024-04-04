Affective Uplift During Video Game Play: A Naturalistic Case Study

- preprint: <https://osf.io/preprints/psyarxiv/z3ejx>
- [This repository](https://github.com/digital-wellbeing/pws-data) contains the data and code described in our manuscript.

Authors:

- Matti Vuorre (mjvuorre@uvt.nl) 
- Nick Ballou (joint first author)
- Thomas Hakman
- Kristoffer Magnusson
- Andrew K. Przybylski

## Data 

The data is documented and archived at <https://osf.io/wpeh6/> (<https://psyarxiv.com/kyn7g>).

## Reproduce

The analysis code is written in R. The source code of the manuscript (including all data wrangling and analysis) is in `ms.Rmd`. To reproduce:

1. Get the materials, for example

```bash
git clone https://github.com/digital-wellbeing/pws-prepost.git
cd pws-prepost
```

2. Specify appropriate environment variables in `.Renviron.example`.

3. Run code either with [`make`](https://www.gnu.org/software/make/), or
  - Restore the R environment with `renv::restore()`
  - Render the manuscript with `rmarkdown::render("ms.Rmd")`

Note that some computations can take a very long time indeed, depending on computer performance etc.

## Contribute

To contribute, open an issue and/or send a pull request at <https://github.com/digital-wellbeing/pws-prepost>.
