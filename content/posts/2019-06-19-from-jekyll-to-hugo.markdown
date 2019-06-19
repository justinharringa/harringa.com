---
layout: post
title:  "From Jekyll to Hugo"
date:   2019-06-19 07:38:42 -0700
tags:
- jekyll
- hugo
- github
- pull-request
- disqus
- github-actions
- jamstack
---
I have decided to switch the site over to [Hugo][hugo] from [Jekyll][jekyll]. In the process, I also switched from
using [Travis CI][travis] to [GitHub Actions][github-actions]. I'll cover the CI switch in a follow-on post. 
In this post, I'll cover the motivations and what I did to switch.

[Jekyll][jekyll] served me quite well for quite some time but there are a few factors that motivated the switch:

1. **Ruby toolchain updates** This isn't really [Jekyll][jekyll]'s fault. I just don't really do much Ruby development
any longer and, since it's pretty obvious that I don't post here often, I typically find myself wanting/needing to 
do chores such as [updating dependencies][chore] and chasing down any issues. Though, typically there haven't been 
many. I will note that, while I have been doing more [Go][go] development, [Hugo][hugo] is distributed
as a binary and really the only [Go][go] you need to know about relates to [templating][templates] (unless you want 
to contribute).
2. **Batteries included** As evidenced in my [Adding Disqus to Jekyll][disqus-post] post, [Jekyll][jekyll] takes an 
approach where you should install plugins and assemble things yourself. I see some advantages to that for customization
and leaving out dependencies that you don't need. However, this site isn't really all that complicated and I just want 
things like Disqus, pagination, etc... to work.
<!--more-->

In order to [convert the site][site-pr], I used `hugo import jekyll` ([see doc][import]) but also ended up doing some manual tweaking
to make sure that my permalinks were good enough for Disqus to continue working without having to set up additional mapping.
So, I essentially just set the `url` for old posts to set the permalinks. I had considered contributing to the 
[import jekyll][import] command but wasn't quite familiar enough with [Go][go] and [Hugo][hugo] to do that and my site 
is pretty small. I did the full conversion between the [theme repo][theme] and a single [pull request][site-pr] for illustration. In
the [pull request][site-pr], you'll notice some other tasks that I probably could have done earlier such as improving the markdown
formatting, getting some consistency, as well as the conversion to [GitHub Actions][github-actions].

## Leftovers
There are a few leftovers from this work that I've got on my list of TODOs.
### Theme Reuse
I would like to get the [bota-hugo-theme][theme] in better shape for others to use. It's sitting pretty good right now but there are
a few [issues][theme-issues] that I'd like to address still. Feel free to contribute and add issues!
### Follow-on Posts
* Post about the motivations, process, and experience of switching from [Travis CI][travis] to [GitHub Actions][github-actions] (hint: 
I really like [GitHub Actions][github-actions])
* I created [actions-s3_website][s3-action] and would like to post about that.
* Post about the [bota-hugo-theme][theme]

Other than that, I'm fairly happy with the switch!

[hugo]: https://gohugo.io/
[templates]: https://gohugo.io/templates/
[jekyll]: https://jekyllrb.com/
[disqus-post]: /posts/2015/12/19/adding-disqus-to-jekyll-site/
[site-pr]: https://github.com/justinharringa/harringa.com/pull/25
[chore]: https://github.com/justinharringa/harringa.com/pull/24
[theme]: https://github.com/justinharringa/bota-hugo-theme
[theme-issues]: https://github.com/justinharringa/bota-hugo-theme/issues
[go]: https://golang.org/
[import]: https://gohugo.io/commands/hugo_import_jekyll/
[s3-action]: https://github.com/justinharringa/actions-s3_website
[travis]: https://travis-ci.org/
[github-actions]: https://github.com/features/actions
