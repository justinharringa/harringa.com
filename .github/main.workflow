workflow "CD" {
  resolves = ["Hugo broken link check with muffet"]
  on = "push"
}

action "Hugo broken link check with muffet" {
  uses = "peaceiris/actions-hugo-link-check@v0.55.6"
  env = {
    HUGO_OPTIONS = "-t bota"
  }
}
