---
layout: post
title:  "Adding Disqus to Jekyll Site"
date:   2015-12-19 16:34:42 -0300
url: posts/2015/12/19/adding-disqus-to-jekyll-site/
tags: 
- disqus
- jekyll
- continuous-delivery
- snap-ci
- liquid
- continuous-integration
- travis-ci
---
As I mentioned in my [Hello Jekyll!][hello-jekyll] post, I'm administering this site with [Jekyll][jekyll]. I've got 
all of my code in [GitHub][gh-site] and am using [Travis CI][travis-ci] for continuous integration / continuous delivery of 
the site. That's been working quite well thus far, though I'd like to add more testing utilities. 

One thing that was missing once I moved my blog from Blogger to [Jekyll][jekyll] was a commenting system. I've seen 
[Disqus](https://disqus.com/) used quite frequently and it seemed like a nice way to get a commenting system introduced
without adding annoyances to users (or for me) since it allows people to use Disqus credentials or credentials from 
various other providers (e.g. Facebook). 
<!--more-->
Process
---
The process was fairly simple. You basically just do the following:

1. Register your site
1. Add the [Universal Embed Code](https://disqus.com/admin/universalcode/) to your site however you'd like, or follow 
their [instructions for Jekyll](https://help.disqus.com/customer/portal/articles/472138-jekyll-installation-instructions)
1. Edit the variables in the code to provide your canonical URL and page identifier

The nice thing about [Jekyll][jekyll] is that you can use [Liquid][liquid] to fill this in for you. So here's what I 
ended up doing to suit this need within my 
[template file specifically for Disqus](https://github.com/justinharringa/harringa.com/blob/master/_includes/disqus.html):

{{< highlight javascript >}}
<script>
  var disqus_config = function () {
    this.page.url = "{{ page.url | replace:'index.html','' | prepend: site.baseurl | prepend: site.url }}";
    this.page.identifier = "{{ page.id }}";
  };
  (function() { // DON'T EDIT BELOW THIS LINE
    var d = document, s = d.createElement('script');
    {% if jekyll.environment == "production" %}
      {% assign disqus_id = 'harringa' %}
    {% else %}
      {% assign disqus_id = 'harringadev' %}
    {% endif %}
    s.src = '//{{ disqus_id }}.disqus.com/embed.js';

  ...
{{< / highlight >}}

You'll notice that I'm also using separate Disqus shortnames for environments per their recommendation. [Jekyll][jekyll]
provides a jekyll.environment which defaults to 'development' if you haven't set a JEKYLL_ENV environment variable. So,
in my [Travis CI][travis-ci] configuration, I simply do just that. This way I can test out Disqus without worrying about 
accidentally posting test comments to my production site.

Editorial note: I was using Snap CI from ThoughtWorks but they have recently shut down that product. I've moved this to Travis CI
and have updated the links.

[liquid]: https://github.com/Shopify/liquid/wiki
[jekyll]: http://jekyllrb.com/
[hello-jekyll]: {{< ref 2015-11-15-hello-jekyll >}}
[travis-ci]: https://travis-ci.org/justinharringa/harringa.com
[gh-site]: https://github.com/justinharringa/harringa.com
