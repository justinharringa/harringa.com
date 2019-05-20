workflow "CD" {
  resolves = ["Hugo broken link check with muffet"]
  on = "push"
}
action "Submodule init" {
  uses = "docker://alpine/git"
  args = ["submodule", "init"]
}
action "Submodule update" {
  uses = "docker://alpine/git"
  args = ["submodule", "update"]
  needs = ["Submodule init"]
}
action "Shell" {
  uses = "actions/bin/sh@master"
  args = ["ls -ltrR"]
  needs = ["Submodule update"]
}
action "Hugo broken link check with muffet" {
  uses = "peaceiris/actions-hugo-link-check@v0.55.6"
  env = {
    HUGO_OPTIONS = "-t bota"
  }
  needs = ["Shell"]
}
