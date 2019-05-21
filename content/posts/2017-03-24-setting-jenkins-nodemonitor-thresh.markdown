---
layout: post
title:  "Setting Jenkins Node Monitor Thresholds with Groovy"
date:   2017-03-24 18:28:42 -0700
url: posts/2017/03/25/setting-jenkins-nodemonitor-thresh/
tags:
- jenkins
- configuration
- groovy
---
Today I ran across a case where we were trying to programmatically set the threshold for when [Jenkins][jenkins] 
will automatically turn off a [Jenkins][jenkins] agent (found under `https://$YOUR_JENKINS_HOST/computer/configure`). 
The default is `1GB` and we'd like to bump that up a bit. We're periodically wiping out any nodes that are 
offline (as well as the resources behind that node) so doing this will clean them out sooner. 

<!--more-->
Discovering how to do this turned out to be a bit trickier than normal. After some research I discovered that the 
[DescribableList][describable-list] that comes from [ComputerSet][computer-set].getMonitors() was the ticket. 
[DiskSpaceMonitor][disk-space-monitor] is obviously an idempotent object based on the doc so it seemed that replacing 
it somewhere was what was necessary. So, if you would like to replace any of the [NodeMonitor][node-monitors]s in the 
[hudson.node_monitors][node-monitors] package (listed under `https://$YOUR_JENKINS_HOST/computer/configure`) then you 
can do something similar to this:

{{< highlight groovy >}}
import hudson.node_monitors.DiskSpaceMonitor
ComputerSet.getMonitors().replace(new DiskSpaceMonitor("5GB"))
{{< / highlight >}}

Groovy!

[jenkins]: https://jenkins.io/
[computer-set]: http://javadoc.jenkins.io/index.html?hudson/model/ComputerSet.html
[describable-list]: http://javadoc.jenkins.io/index.html?hudson/util/DescribableList.html
[node-monitors]: http://javadoc.jenkins.io/index.html?hudson/node_monitors/package-summary.html
[disk-space-monitor]: http://javadoc.jenkins.io/index.html?hudson/node_monitors/DiskSpaceMonitor.html
