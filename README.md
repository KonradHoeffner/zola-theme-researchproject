# zola-theme-researchproject

A reusable [Zola](https://www.getzola.org/) theme for research project and research group websites. It is a port of the Poole/Hyde design used by the TOP, SNIK, HITO and ANNO websites, with the accumulated fixes and customisations in one place.

The repository contains:

- the theme at the root (`theme.toml`, `templates/`, `static/`)
- a starter site in `template/`
- scripts for local development and for creating new sites

The theme is tested with **Zola 0.23.6**. Zola 0.23 renamed the config file to `zola.toml` and moved to Tera 2, so pin the Zola version in CI.

## Local demo

```sh
./scripts/dev-link.sh
cd template
zola serve --port 1111
```

Open <http://127.0.0.1:1111>. To build the static site:

```sh
cd template
zola build
```

The output is written to `template/public/`.

`scripts/dev-link.sh` creates the symlink `template/themes/researchproject -> ../..`. The symlink is ignored by git. A real site uses a git submodule instead.

## Creating a new site

```sh
./scripts/new-site ../my-project \
  --title "My Research Project" \
  --url "https://example.org" \
  --tagline "A short tagline" \
  --color "#6e8fb1"
```

The script copies `template/`, replaces the example configuration, initialises a git repository, and adds the theme as a submodule pinned to `v0.2.0`.

Other options:

```text
--description TEXT      Site description
--github URL            GitHub link, or "" to hide it
--theme-version TAG     Theme tag to pin (default: v0.2.0)
--theme-repo URL        Theme repository URL
--theme-path PATH       Use a local theme directory instead of a submodule
```

`--theme-path` is useful before the theme repository is published. It creates a local symlink, which should not be committed.

After creating the site:

```sh
cd ../my-project
zola serve
```

## Repository layout

```text
theme.toml                  theme metadata and default [extra] values
templates/                  base, index, page, section, publications, 404
static/css/                 poole, hyde, syntax and theme CSS
template/                   starter site and live demo
  zola.toml                 title, URL, tagline, colour, logo, GitHub link
  content/                  one Markdown file per page
  static/logo.svg           placeholder logo
  static/publications.bib   publication data and download
  themes/                   theme submodule in real sites
scripts/dev-link.sh         local symlink for the demo
scripts/new-site            copy the starter and add the theme submodule
.github/workflows/ci.yml    build the demo against the local theme
```

`template/` is a starter, not part of the theme. Zola ignores it when the theme is used from `themes/researchproject`. A site that uses this repository as a submodule does receive the `template/` directory as well; it is small and ignored by Zola. If that becomes annoying, the repository can be split into a theme repository and a separate template repository later.

## How Zola theming works

Zola has no `remote_theme` feature. A theme is a normal directory in `themes/<name>` containing `theme.toml`, `templates/`, `static/` and optionally `sass/`. The site enables it with:

```toml
theme = "researchproject"
```

A site can:

- override any theme file by creating the same path under its own `templates/` or `static/`
- extend a theme template with `{% extends "researchproject/templates/base.html" %}`
- override theme `[extra]` defaults in its own `[extra]` table

For a real site, the theme is a pinned submodule:

```sh
git submodule add https://github.com/KonradHoeffner/zola-theme-researchproject.git themes/researchproject
cd themes/researchproject
git checkout v0.2.0
```

Then clone the site with `--recurse-submodules`, or run `git submodule update --init --recursive`.

## Configuration

Everything project-specific lives in the site's `zola.toml`:

```toml
base_url = "https://example.org"
title = "Example Research Project"
description = "A starter site for research projects and research groups."
default_language = "en"
theme = "researchproject"

[extra]
tagline = "A reusable Zola starter for research projects"
theme_color = "#6e8fb1"
logo = "logo.svg"
favicon = "logo.svg"
fonts = true
github = ""
```

- `theme_color` is used for the sidebar and content links.
- `logo` and `favicon` are paths inside `static/`.
- `fonts = false` disables Google Fonts, which is useful if you do not want requests to Google from EU visitors.
- `github = ""` hides the GitHub link in the sidebar.

Navigation is generated from `content/*.md`, sorted by `weight`. Pages with `hidden = true` are built but omitted from the sidebar; they are still publicly accessible.

## Publications

`static/publications.bib` is the only source of publication data. The publications template uses:

```tera
{% set bib = load_data(path="publications.bib", format="bibtex") %}
```

The explicit `format="bibtex"` is required in Zola 0.23.6. Without it, the file is loaded as plain text and `bib.bibliographies` is empty.

Each entry becomes `<article id="CITATION_KEY">`, so existing links such as `publications#topframework2026` keep working. The page groups entries by year and renders a collapsible `<details>` block containing the reconstructed BibTeX. The same file is linked as the download.

Optional fields understood by the template:

```text
pdf, url, doi, journal, booktitle, series, volume, number,
pages, publisher, note
```

For a PDF, use a path inside `static/`, for example:

```bibtex
pdf = {public/papers/example.pdf}
```

## Deployment

Zola is not built natively by GitHub Pages. A generated site includes `.github/workflows/build.yml`, which:

1. checks out the site with `submodules: recursive`
2. installs Zola 0.23.6
3. runs `zola build`
4. uploads `public/` as a Pages artifact
5. deploys it with `actions/deploy-pages`

In the repository settings, set **Pages → Source** to **GitHub Actions**.

For a project page served from `https://user.github.io/repo/`, set:

```toml
base_url = "https://user.github.io/repo"
```

For a custom domain, set `base_url` to the domain and add `static/CNAME` containing the domain.

## Versioning

The theme is versioned with git tags, for example `v0.2.0`. A site records the exact theme commit in its submodule. Updating the theme is deliberate:

```sh
cd themes/researchproject
git fetch --tags
git checkout v0.3.0
cd ../..
git add themes/researchproject
git commit -m "Update theme to v0.3.0"
```

A theme update does not silently change every site.

## CI in this repository

`.github/workflows/ci.yml` builds `template/` against the theme in the same commit. It creates the development symlink, runs `zola build`, and runs `zola check`. This is the integration test for theme and starter changes.

## Known limitations

- The logo and team members are placeholders.
- Author names are displayed as `Family, Given`, which is how they are stored in BibTeX.
- The theme uses plain CSS, not Sass.
- There is no automatic migration of the existing TOP, SNIK, HITO and ANNO sites.
- The one-repository layout means theme consumers also receive the small `template/` directory; Zola ignores it.

## License

MIT. The CSS is derived from [Poole](https://github.com/poole/poole) and [Hyde](https://github.com/poole/hyde) by Mark Otto. See `LICENSE.md`.
