workflow "CD" {
  resolves = ["Hugo broken link check with muffet"]
  on = "push"
}
action "Submodule init/update" {
  uses = "docker://alpine/git"
  args = ["submodule init", "submodule update"]
}
action "Shell" {
  uses = "actions/bin/sh@master"
  args = ["ls -ltrR"]
  needs = ["Submodule init/update"]
}
action "Hugo broken link check with muffet" {
  uses = "peaceiris/actions-hugo-link-check@v0.55.6"
  env = {
    HUGO_OPTIONS = "-t bota"
  }
  needs = ["Shell"]
}
