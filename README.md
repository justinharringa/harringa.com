[![Deploy Site](https://github.com/justinharringa/harringa.com/actions/workflows/main.yml/badge.svg)](https://github.com/justinharringa/harringa.com/actions/workflows/main.yml)

# Purpose

My personal site, which generally gets used as a playground. Built with [Hugo](https://gohugo.io/) using the [bota-hugo-theme](https://github.com/justinharringa/bota-hugo-theme) (pulled in as a git submodule).

# Getting Started

The theme lives in a submodule, so clone with submodules:

```
git clone --recurse-submodules https://github.com/justinharringa/harringa.com.git
```

(Or, if you already cloned without `--recurse-submodules`, run `git submodule update --init --recursive`.)

Install [Hugo extended](https://gohugo.io/installation/) — the theme uses SCSS, so the extended build is required.

For a local preview with drafts, live reload, and future-dated posts:

```
hugo server -D -F
```

For a production build matching what CI runs:

```
hugo --theme=bota
```

Site configuration lives in `config.yaml`; content lives under `content/`.

# Deployment

Pushes to `main` trigger [`.github/workflows/main.yml`](.github/workflows/main.yml), which builds the site with Hugo and deploys the `public/` output to the `www.harringa.com` S3 bucket via the [justinharringa/s3_website](https://github.com/justinharringa/actions-s3_website) Docker image. The same action invalidates the CloudFront distribution on each deploy.

Pull requests run [`.github/workflows/pr.yml`](.github/workflows/pr.yml), which builds with Hugo as a sanity check but does not deploy.
