# garthdb.github.io [![Build and deploy Jekyll site](https://github.com/GarthDB/garthdb.github.io/actions/workflows/jekyll.yml/badge.svg)](https://github.com/GarthDB/garthdb.github.io/actions/workflows/jekyll.yml)

Public site.

## Development

- **Ruby:** 3.3.4 (see `.ruby-version` for rbenv). Run `rbenv install` then `bundle install` to install gems.
- **Node:** Used for stylelint. Run `npm install` to install dev dependencies.

```bash
bundle exec rake watch    # Serve site with live reload
bundle exec rake test     # Lint and run HTML Proofer
```

## Deployment

The site is built and deployed with GitHub Actions. To enable it:

1. Open the repo **Settings → Pages**.
2. Under **Build and deployment**, set **Source** to **GitHub Actions**.

Pushes to `main` will build the Jekyll site, run linting and HTML Proofer, and deploy to GitHub Pages.
