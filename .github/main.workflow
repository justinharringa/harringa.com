workflow "CD" {
  on = "push"
  resolves = ["Slack me master"]
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
  env = {
    HUGO_DESTINATION = "/github/workspace/public"
    HUGO_ENV = "production"
  }
}

action "Prod s3_website push" {
  uses = "docker://justinharringa/s3_website:master"
  needs = ["Build"]
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "AWS_CLOUDFRONT_DISTRIBUTION"]
  args = "push --site public"
  env = {
    S3_BUCKET = "www.harringa.com"
  }
}
action "Slack me master" {
  uses = "pullreminders/slack-github-action@master"
  needs = ["Prod s3_website push"]
  args = "{\"channel\":\"C3USVSXS6\",\"text\":\"master ready! Head to https://harringa.com to review\"}"
  secrets = ["SLACK_BOT_TOKEN"]
}

workflow "PR" {
  resolves = ["Slack me PR"]
  on = "push"
}

action "actor-filter" {
  uses = "actions/bin/filter@master"
  args = "actor justinharringa"
}

action "Not master" {
  uses = "actions/bin/filter@master"
  args = "not branch master"
  needs = ["actor-filter"]
}

action "PR-filter" {
  uses = "actions/bin/filter@master"
  args = "ref refs/heads/*"
  needs = ["Not master"]
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
  env = {
    HUGO_DESTINATION = "/github/workspace/public"
  }
}

action "No cloudfront in s3_website.yml" {
  uses = "docker://alpine/git"
  runs = ["/bin/sh", "-c", "sed -i '/cloudfront_distribution_id/d' ./s3_website.yml"]
  needs = ["PR Build"]
}

action "PR s3_website push" {
  uses = "docker://justinharringa/s3_website:master"
  needs = ["No cloudfront in s3_website.yml"]
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
  args = "push --site public"
  env = {
    S3_BUCKET = "pr.review.harringa.com"
  }
}

action "Slack me PR" {
  uses = "pullreminders/slack-github-action@master"
  needs = ["PR s3_website push"]
  args = "{\"channel\":\"C3USVSXS6\",\"text\":\"PR ready! Head to http://pr.review.harringa.com.s3-website-us-west-2.amazonaws.com/ to review\"}"
  secrets = ["SLACK_BOT_TOKEN"]
}
