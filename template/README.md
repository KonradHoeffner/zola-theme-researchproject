# Example Research Project

A Zola starter site for a research project or research group. It uses the
`researchproject` theme and keeps publications in a single BibTeX file.

## First run

If this site was created with `scripts/new-site`, the theme submodule is already
initialised. If you copied `template/` manually, add it first:

```sh
git submodule add https://github.com/KonradHoeffner/zola-theme-researchproject.git themes/researchproject
cd themes/researchproject
git checkout v0.2.0
cd ../..
```

Then build or serve:

```sh
zola serve
# or
zola build
```

The output is written to `public/`.

## Customise

Edit `zola.toml`:

- `title`, `description`, `base_url`
- `[extra].tagline`
- `[extra].theme_color`
- `[extra].logo` and `[extra].favicon`
- `[extra].fonts` (`false` disables Google Fonts)
- `[extra].github` (empty hides the GitHub link)

Replace `static/logo.svg` with your own logo. The placeholder is white on a
transparent background so it is visible on the coloured sidebar.

Pages live in `content/`. Their order in the sidebar is controlled by `weight`:

| Page | Weight |
| --- | --- |
| Home | 5 |
| Project | 10 |
| Goals | 15 |
| Work packages | 20 |
| Results | 30 |
| Publications | 31 |
| Theses | 33 |
| Internal | 35, hidden |
| Contact | 80 |
| Imprint | 99 |

`hidden = true` builds the page but leaves it out of the navigation. The page is
still public, so do not put secrets there.

## Publications

Edit `static/publications.bib`. Each entry keeps its citation key as an HTML
anchor, so links like `publications#topframework2026` continue to work.

The renderer understands `author`, `title`, `journal`, `booktitle`, `series`,
`volume`, `number`, `pages`, `year`, `publisher`, `doi`, `url`, `note` and
`pdf`. For a PDF, use a path inside `static/`, for example:

```bibtex
pdf = {public/papers/example.pdf}
```

## Deployment

The included GitHub Actions workflow builds the site with
`submodules: recursive` and deploys `public/` to GitHub Pages. In the
repository settings, set **Pages → Source** to **GitHub Actions**.

For a project page under `https://user.github.io/repo/`, set:

```toml
base_url = "https://user.github.io/repo"
```

For a custom domain, set the domain as `base_url` and add `static/CNAME`
containing the domain.
