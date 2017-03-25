[![Build Status](https://travis-ci.org/justinharringa/harringa.com.svg?branch=master)](https://travis-ci.org/justinharringa/harringa.com)

# Purpose 

My personal site which generally gets used as a playground. Though I am 
planning on adding some more serious content soon.

# Getting Started
To run the Jekyll process:
* bundle install
* bundle exec rake test

# Responsive images
Images are created by using Gulp and [gulp-responsive](https://npmjs.com/gulp-responsive). The images need
to be referenced in the html/css files in order to be processed (this is what triggers them to be created/minified).
At the moment, this portion is run on the developer machine and the images are checked into git.
Eventually it may be nice to put this in the deployment pipeline. However, some installation requirements
make that take more time than I'd like in the pipeline. The current Rakefile is checking links so if this hasn't been 
run on some new images that are supposed to be responsive, then the build will fail (which should trigger the memory that
this will need to be run). 

Requirements:
- NPM
- ```npm install``` in this directory

Running: 
* Simply run ```gulp```
