workflow "CD" {
  resolves = ["PR s3_website push"]
  on = "push"
}

action "PR-filter" {
  uses = "actions/bin/filter@master"
  args = "ref refs/pulls/*"
}

action "Submodule init" {
  uses = "docker://alpine/git"
  args = ["submodule", "init"]
  needs = ["PR-filter"]
}

action "Submodule update" {
  uses = "docker://alpine/git"
  args = ["submodule", "update"]
  needs = ["Submodule init"]
}

action "Build" {
  uses = "docker://klakegg/hugo:0.55.6-ext"
  needs = "Submodule update"
  args = "--theme=bota"
}

action "PR s3_website push" {
  uses = "docker://justinharringa/s3_website:master"
  needs = ["Build"]
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
  args = "push --site build"
  env = {
    S3_BUCKET = "pr.review.harringa.com"
  }
}
