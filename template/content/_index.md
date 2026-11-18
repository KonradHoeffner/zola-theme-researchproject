+++
title = "Home"
sort_by = "weight"
template = "index.html"
page_template = "page.html"
+++

# Example Research Project

**A reusable starting point for research project and research group websites.**

This site is built with [Zola](https://www.getzola.org/) and the local `researchproject` theme. The design is a port of the Poole/Hyde layout used by the TOP, SNIK, HITO and ANNO websites, with the accumulated fixes and customisations folded into one place.

- One theme, many project sites: colours, logo, title, tagline and navigation come from `zola.toml`.
- Publications live in a single BibTeX file instead of hand-written HTML.
- Static HTML output, no client-side JavaScript required.
- The same BibTeX file is rendered on the publications page and offered as a download.

## Getting started

Edit `zola.toml`, replace `static/logo.svg` and `static/publications.bib`, then run:

```sh
./serve.sh
```

The development server is available at `http://127.0.0.1:1111`. Run `./build.sh` to produce the static site in `public`.
