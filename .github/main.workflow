workflow "CD" {
  resolves = ["Prod s3_website push", "PR s3_website push"]
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

action "Build" {
  uses = "srt32/hugo-action@v0.0.3"
  needs = "Submodule update"
  args = "--theme=bota"
}

action "Master Branch" {
  needs = ["Build"]
  uses = "actions/bin/filter@b2bea07"
  args = "branch master"
}

action "Prod s3_website push" {
  uses = "docker://justinharringa/s3_website:master"
  needs = ["Master Branch"]
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "AWS_CLOUDFRONT_DISTRIBUTION"]
  args = "push --site build"
  env = {
    S3_BUCKET = "www.harringa.com"
  }
}

action "PR-filter" {
  uses = "actions/bin/filter@master"
  args = "ref refs/pulls/*"
  needs = ["Build"]
}

action "PR s3_website push" {
  uses = "docker://justinharringa/s3_website:master"
  needs = ["PR-filter"]
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
  args = "push --site build"
  env = {
    S3_BUCKET = "pr.review.harringa.com"
  }
}
