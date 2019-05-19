---
layout: post
title:  "Open Sourcing Dockerfile Image Update"
date:   2018-04-08 12:40:42 -0700
tags:
- docker
- github
- pull-request
- security
---
My colleague Andrey Falko recently published a [post][post] on the [Salesforce engineering blog][blog] about a tool
we built and open sourced called [Dockerfile Image Update][diu]. It's a pretty nice way of pushing pull requests to
child Docker images when a parent image has changed while avoiding using the `latest` tag by plugging it into your
CI/CD flow. [Check it out!][post]

[post]: https://engineering.salesforce.com/open-sourcing-dockerfile-image-update-6400121c1a75
[blog]: https://engineering.salesforce.com/
[diu]: https://github.com/salesforce/dockerfile-image-update
<!--more-->

