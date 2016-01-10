require 'html/proofer'

task :test do
  sh "bundle exec jekyll build"
  sh "gulp"
  HTML::Proofer.new("./_site", {:disable_external => true}).run
end
