---
layout: header-image-post
title:  "I am a Jekyll God"
date:   2015-01-06 10:21:23
headerimg: /img/jekyll_god.jpg
articleclass: left
---
We’ve used [Jekyll](http://jekyllrb.com/) and [GitHub Pages](https://pages.github.com/) to host [DesignOpen.org](http://designopen.org/) since we published the first line of code and although we love our setup, we haven’t taken full advantage of the system; until last week’s [pull request](https://github.com/DesignOpen/designopen.github.io/pull/157). After making said pull request, and being drunk on the power of a [Google PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/?url=designopen.org) score of 96, I made this hasty declaration to [Una](http://www.twitter.com/una) on our team Slack:

> *[11:25 PM]*  
> I got travis hooked up on the site  
> *[11:25 PM]*  
> and minified everything  
> *[11:25 PM]*  
> **I AM A JEKYLL GOD!**  
> *[11:26 PM]*  
> I get full of myself when I stay up late  
> I need to go to bed.  

Although it’s a bit of a stretch to declare myself a Jekyll God, you too can become one, following these simple steps that other people have published and that I have taken advantaging of by compiling them in this article.

## Open Blog Requirements

Design Open is an open source blog; it is designed to allow community members to publish articles and front end contributions by making pull requests to our [main GitHub repository](http://github.com/DesignOpen/designopen.github.io). Also, we want new contributions to go live as soon as we accept the pull request. This requirement means we don’t use any custom Jekyll plugins or local build steps. No Gulp, Grunt, Rake, or manual stuff. We thought this would mean we’d have to compromise on loading speed, but we’ve found some great workarounds.

## Minify and Inline the Styles

Jekyll and GitHub Pages now support [Sass](http://sass-lang.com/) and [CoffeeScript](http://coffeescript.com/) by default, so you can take full advantage of the file size optimization available with Sass.

In your __config.yml_ you can configure Sass to output compressed css; checkout the _style: compressed_ line of our configuration file:

{% highlight yaml linenos %}
permalink: /:categories/:title/
highlighter: pygments
url: http://designopen.org
name: Open Source Design
excerpt_separator: <!--more-->
markdown: kramdown
exclude: [vendor]
sass:
  sass_dir: _sass
  style: compressed
{% endhighlight %}

You can also take advantage of Sass’s import to concatenate all your styles into a single file. The main benefit of a single stylesheet is that it greatly reduces the number of server requests when first loading the page. However, while we want a single final stylesheet, we also love breaking our styles in as many files as possible to help organize the ever growing beast that is a styled website. Here is our _main.scss_:

{% highlight scss linenos %}
@import "normalize";
@import "fonts";

@import "mixins";
@import "base";
@import "type";
@import "article";
@import "header";
@import "footer";
@import "video";

@import "todo"; //junk file for later placement
{% endhighlight %}

It’s really just an empty shell of a file that spends it’s life trying to get other resources to work together; like a middle manager.

Now we can take our stylesheets to the next level by embedding them in the_&lt;head&gt;_. The decision to embed styles in the html is based on the size of the CSS file. With smallish CSS files, inlining can improve page speed by removing the additional server requests. Google has a great explanation of the benefits of inlining on their [developer docs](https://developers.google.com/speed/docs/insights/OptimizeCSSDelivery).

I learned about using Jekyll to embed the css from [Kevin Sweet’s blog](http://www.kevinsweet.com/inline-scss-jekyll-github-pages/). It requires you move your main sass (or scss) file to the __includes_ directory and then include it while passing it through the new _sassify_ or _scssify_ filter. Here’s the example from Kevin’s blog:

{% highlight html linenos %}
<head>
  <style type="text/css">
    {{"{% capture include_to_scssify " }}%}
      {{"{% include style.scss " }}%}
    {{"{% endcapture " }}%}
    {{ "{{ include_to_scssify | scssify " }}}}
  </style>
</head>
{% endhighlight %}

A quick note, since your _main.scss_ file is now in the __includes_ directory and isn’t being parsed like a normal Jekyll Sass file, don’t include the Jekyll [front matter](http://jekyllrb.com/docs/frontmatter/) that is normally required. Also, you can still import any Sass file from your configured Sass folder, into your primary Sass stylesheet, without having to change the import paths; pretty nifty.

## Minify the HTML

Unlike Sass, Jekyll does not, by default, have an option for minifying the generated HTML. Originally I had assumed we would be stuck with fat HTML, since we were avoiding anything outside of the default Jekyll setup, but I found a solution from [Anatol Broder](http://penibelst.de/) that solves the problem wonderfully.

Anatol created a Jekyll layout that removes unnecessary whitespace from the content. To use it in your site, just download the [_compress.html_](https://github.com/penibelst/jekyll-compress-html/releases/tag/v1.1.1) layout and put it in your __layouts _directory. Then set any root level layout or html file to be based on _compress_. For example, our _default.html_ layout includes this front matter:

{% highlight yaml linenos %}
---
layout: compress
---
{% endhighlight %}

## Adding Tests

The final step to becoming a God of the open blog, is to add automated tests to you public repository. The main goal is to verify that any new code contributed will not break the Jekyll build process before you invest the time to review the pull request. However, you can also use the opportunity of running tests to check for broken links using the HTML Proofer Library.

This tip comes directly from [Jekyll’s documentation](http://jekyllrb.com/docs/continuous-integration/) on automation, but we’ve tweaked it a bit for DesignOpen. I ended up using [Rake](https://github.com/ruby/rake) to configure and run the _test_ task; this route seems a bit more standard since Rake is fairly popular in Ruby projects, and it makes it easier to run the test locally.

To automate your tests, use [Travis CI](https://travis-ci.org/). It is a free service for public GitHub repositories and it will run tests automatically on every push; I highly recommend it for all testable projects

Before you can automate the test, you need to turn on Travis CI for your repo in your [profile](https://travis-ci.org/profile/). Then, add a _.travis.yml_ file to your root directory, which configures how the test should be run.

{% highlight yaml linenos %}
language: ruby
rvm:
- 2.1
script: bundle exec rake test
env:
  global:
  - NOKOGIRI_USE_SYSTEM_LIBRARIES=true
{% endhighlight %}


Most of this example is self explanitory; the _script_ property is the command that is run, and the _env_ is something that the Jekyll documentation says will speed up the gem installation process of the test. I have no idea if that’s true; I’m just taking it on blind faith.

You also need to create a _:test_ task in your Rakefile. If you aren’t already using Rake, just use something like this:

{% highlight ruby linenos %}
require 'html/proofer'
# rake test
desc "build and test website"
task :test do
  sh "bundle exec jekyll build"
  HTML::Proofer.new("./_site", {:href_ignore=> ['http://localhost:4000'], :verbose => true}).run
end
{% endhighlight %}

I’m not going to do a deep dive into Rake here, but the important parts are on lines _5_ and _6_. First it builds the Jekyll site, then it uses the [HTML Proofer](https://github.com/gjtorikian/html-proofer)gem to check that all the URLs in the __site_ directory are active. I wanted to see where errors occured, so I set _vebose_ to _true_ and we also use a local url in one our articles, so I added the _:href_ignore_ to avoid the known error. Checkout the gem’s [_README.md_](https://github.com/gjtorikian/html-proofer/blob/master/README.md)_ _for the full documentation on the options

The final step is to add the necessary gems to your Gemfile.

{% highlight ruby linenos %}
source 'https://rubygems.org'
gem 'github-pages'

# Test the build
group :test do
  gem 'rake'
  gem 'html-proofer'
end
{% endhighlight %}

Use the _:test_ group for the gems that are only necessary for Travis CI to build and test..

When it’s all set up correctly, you’ll see a Travis status on every pull request.

<figure>
  <img src="/img/travis_tests_passed.png" alt="Travis tests"/>
</figure>

## Divine Limitations

Despite our jekyllian apotheosis, we are not quite omnipotent. We are close to a 100/100 score on Google’s PageSpeed Insights, but the last few remainig warnings pertain to serverside caching policy issues. While GitHub pages are excellent, we aren’t given the ability to change those policies. I’ve already submitted the issue to GitHub, so hopefully that changes in the near future.

<figure>
  <img src="/img/insights.png" alt="PageSpeed Insights"/>
</figure>

## A Final Warning

Although your new found power is real, and potentially useful, it’s not exactly super. Don’t let its intoxicating influence blind you to social contexts; these optimizations are not interesting enough to mention at dinner parties, and you should probably avoid referring to yourself as a god in any context.

So use your knowledge wisely, and if you come across any other optimizations, feel free to let me know, and I’ll be sure to capitalize on your kindness by putting them in this article.
