---
layout: post
title: Sacrificial Architecture
date: '2014-11-19T07:25:00.003-06:00'
author: Justin
tags:
- design
- code
- architecture
- infrastructure
modified_time: '2014-11-19T07:35:55.008-06:00'
blogger_id: tag:blogger.com,1999:blog-3129376439018684576.post-5078308425876151030
blogger_orig_url: http://randommusingsbyjustin.blogspot.com/2014/11/sacrificial-architecture.html
excerpt_separator: <br />
---

Martin Fowler recently posted a new bliki about the concept of <a href="http://martinfowler.com/bliki/SacrificialArchitecture.html" target="_blank">sacrificial architecture</a>. He's done a nice job of illustrating the concept so I won't repeat too much here. This definitely falls hand-in-hand with not falling too much in love with your code. I can think back to instances where I or some colleagues may have been resistant to changing portions because they worked well and probably, secretly, we just liked how we put it all together. 
<!--more-->
At some point, parts of your code may let you down because of something you didn't know years or possibly months or weeks ago. I think we've all learned the lesson at one point that this secret love is probably going to cause issues and that it may be best to be somewhat humble about your code. 

This also seems to apply quite well to servers/infrastructure as we see with the movement towards using configuration management and orchestration tools such as <a href="http://puppetlabs.com/puppet/what-is-puppet" target="_blank">Puppet</a>, <a href="https://www.getchef.com/chef/" target="_blank">Chef</a>, <a href="https://www.vagrantup.com/" target="_blank">Vagrant</a>, and <a href="https://www.docker.com/whatisdocker/" target="_blank">Docker</a> to codify, modularize, and automate infrastructure configuration. If your infrastructure configuration is giving you problems and you've procured better hardware or have discovered a better configuration you simply start swapping out "modules" (after testing your changes in some way of course). I don't recall who said it but I have enjoyed a line I heard at a conference that "we need to stop treating servers like pets and instead treat them like farm animals. Go ahead and put them down if they're diseased or are going to hurt others."

In the end, modularity and following good design principles should lead you to more easily sacrifice portions of your code or infrastructure to add features or improve performance (another feature).
