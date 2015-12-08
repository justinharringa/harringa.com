---
layout: post
title:  "Raspberry Pi Temperature Monitor"
date:   2015-12-08 18:45:22 -0300
categories: raspberry-pi experiment brewing python aws dynamodb simpledb
---
I've been wanting to experiment a bit with a [Raspberry Pi kit][rasp-pi] and a [DS18B20 waterproof temperature sensor][temp-sensor] that I bought. 
Well, my wife and I brewed our first beer together in our apartment not too long ago and this seemed like a nice excuse to generate some 
temperature readings to see what temperatures we usually see in our fermentation room. The [temperature sensor][temp-sensor] didn't really have
wiring instructions so I checked out a pretty nice tutorial from [Adafruit][adafruit-tut]. While it doesn't use the same parts, I was able to 
adapt their instructions to what I had for hardware. Once I got it all wired together and working well, I started a new 
[pi-temp-monitor project][pi-temp-monitor] on GitHub. With a little help of the [w1thermsensor][w1thermsensor] module, I was able to whip together 
a project that is currently using cron to store readings to a file. The file writing is being handled by normal unix appending. Overall, I'm pretty
happy with how it's worked out so far. I'd like to get the results posted to [DynamoDB][dynamo] or [SimpleDB][simple] using something like 
[Boto 3][boto3] to generate some charts on my website. I'll be updating the [pi-temp-monitor project][pi-temp-monitor] as I progress.

[rasp-pi]: http://amzn.to/1HToEf5
[temp-sensor]: http://amzn.to/1lMVMe2
[pi-temp-monitor]: https://github.com/justinharringa/pi-temp-monitor
[w1thermsensor]: https://github.com/timofurrer/w1thermsensor
[adafruit-tut]: https://learn.adafruit.com/adafruits-raspberry-pi-lesson-11-ds18b20-temperature-sensing?view=all
[dynamo]: http://aws.amazon.com/documentation/dynamodb/
[simple]: http://aws.amazon.com/documentation/simpledb/
[boto3]: https://boto3.readthedocs.org/en/latest/index.html
