workflow "CD" {
  resolves = ["Prod s3_website push", "PR s3_website push"]
  on = "push"
}

action "Master Branch" {
  uses = "actions/bin/filter@b2bea07"
  args = "branch master"
}

action "Submodule init" {
  uses = "docker://alpine/git"
  args = ["submodule", "init"]
  needs = ["Master Branch"]
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

action "Prod s3_website push" {
  uses = "docker://justinharringa/s3_website:master"
  needs = ["Build"]
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "AWS_CLOUDFRONT_DISTRIBUTION"]
  args = "push --site build"
  env = {
    S3_BUCKET = "www.harringa.com"
  }
}

workflow "PR" {
  resolves = ["PR s3_website push", "Spit out event"]
  on = "push"
}


action "Not master" {
  uses = "actions/bin/filter@master"
  args = "not branch master"
}

action "PR-filter" {
  uses = "actions/bin/filter@master"
  args = "ref refs/heads/*"
  needs = ["Not master"]
}

action "Spit out event" {
  uses = "docker://alpine/git"
  runs = ["sh", "-c", "echo $GITHUB_EVENT"]
  needs = ["PR-filter"]
}

action "PR Submodule init" {
  uses = "docker://alpine/git"
  args = ["submodule", "init"]
  needs = ["PR-filter"]
}

action "PR Submodule update" {
  uses = "docker://alpine/git"
  args = ["submodule", "update"]
  needs = ["PR Submodule init"]
}

action "PR Build" {
  uses = "docker://klakegg/hugo:0.55.6-ext"
  needs = "PR Submodule update"
  args = "--theme=bota"
}

action "PR s3_website push" {
  uses = "docker://justinharringa/s3_website:master"
  needs = ["PR Build"]
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
  args = "push --site build"
  env = {
    S3_BUCKET = "pr.review.harringa.com"
  }
}
