---
layout: post
title:  "Free SSL Certificates"
date:   2016-01-26 08:08:42 -0300
url: posts/2016/01/26/free-ssl-certificates/
tags:
- certificates
- ssl
- privacy
---
I got an e-mail today from [Amazon][amazon] informing me that they have released the [AWS Certificate Manager][aws-cert-manager]
and that they would make it easy to get certificates added to your AWS resources. And, best of all, it is free. 

I had originally intended on using [Let's Encrypt][letsencrypt] for my SSL certificates but I had read about some issues 
with automation and limitations on what you could do. I'm not sure if they've resolved those as of yet but they may have.
<!--more-->
Regardless, I thought I would see if the [AWS Certificate Manager][aws-cert-manager] process was easy enough (and that 
"free" didn't mean that I was giving something up). Sure enough, it was incredibly simple (so simple that I spend no time
automating the process, but that's something I can tackle before my cert renewal). It took me about 10-20 minutes to get
it all set up and then I just had to wait for the change to propagate through [CloudFront][cloudfront].

So, you should notice that now almost everything is https with a nice green lock. Hooray!

[amazon]: https://www.amazon.com
[aws-cert-manager]: http://aws.amazon.com/certificate-manager/
[letsencrypt]: https://letsencrypt.org/
[cloudfront]: https://aws.amazon.com/cloudfront/
