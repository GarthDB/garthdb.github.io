---
layout: header-image-post
title:  "Not Only Sass"
date:   2015-01-06 10:21:23
headerimg: /img/not_only_sass.svg
---
We’ve used [Jekyll](http://jekyllrb.com/) and [GitHub Pages](https://pages.github.com/) to host [DesignOpen.org](http://DesignOpen.org) since we published the first line of code and although we love our setup, we haven’t taken full advantage of the system; until yesterday’s [pull request](https://github.com/DesignOpen/designopen.github.io/pull/157). After making said pull request, and being drunk on the power of a [Google PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/?url=designopen.org) score of 95, I made this hasty declaration on our team Slack:

> *[11:25 PM]*  
> I got travis hooked up on the site  
> *[11:25 PM]*  
> and minified everything  
> *[11:25 PM]*  
> **I AM A JEKYLL GOD!**  
> *[11:26 PM]*  
> I get full of myself when I stay up late  
> I need to go to bed.  

Although it’s a bit of stretch to declare myself a Jekyll God, you too can become one, following these simple steps that other people have published and I am taking advantaging of by compiling them in this article.

#### Open Blog Requirements

Design Open is an open source blog; it is designed to allow community members to publish articles and front end contributions by making pull requests to our [main GitHub repository](http://github.com/DesignOpen/designopen.github.io). Also, we want new contributions to go live as soon as we accept the pull request. This requirement means we don’t use any custom Jekyll plugins or local build steps. No Gulp, Grunt, Rake, or manual stuff. We thought this would mean we’d have to compromise on loading speed, but we’ve found some great workarounds.

#### Minify and Inline the Styles

Jekyll and GitHub Pages now support [Sass](http://sass-lang.com) and [CoffeeScript](http://coffeescript.com) by default, so you can take full advantage of the optimization available with Sass.

In your __config.yml_ you can configure Sass to output compressed css; checkout the _style: compressed_ line of our configuration file:

{% gist GarthDB/b53143edbd26ffd3800c %}

It’s really just an empty shell of a file that spends it’s life trying to get other resources to work together; like a middle manager.

Now we can take our stylesheets to the next level by inlining them in the _&lt;head&gt;_. This might seem like a strange thing to do to improve the page speed since embedding the css in the html negates any benefit of caching the css file, but it all depends on the css file size. Often times an additional request to the server is worse than the additional size of the css in the html. Google has a great explanation on their  [developer docs](https://developers.google.com/speed/docs/insights/OptimizeCSSDelivery).

This trick came from [Kevin Sweet’s blog](http://www.kevinsweet.com/inline-scss-jekyll-github-pages/). It requires you move your main sass (or scss) file to the __includes_ directory and then include and pass it through the new _sassify_ or _scssify_ filter. Here’s the example for Kevin’s blog:

{% gist GarthDB/c142f2ae2df9b06a14d3 %}

A quick note, since our _main.scss_ file is in the __includes_ directory and isn’t being parsed like a normal Jekyll Sass file, we don’t need the front matter. Also, you can still import any sass file stored in your configured sass folder without having to change the import paths; pretty nifty.

#### Minify the HTML

Minifying html is a complicated problem since we are not using any build scripts outside of the default Jekyll and it does not have a minify option, but luckily [Anatol Broder](http://penibelst.de/) has taken all the pain out of the solution with his [_compress.html_](https://github.com/penibelst/jekyll-compress-html) layout.

Just download the [_compress.html_](https://github.com/penibelst/jekyll-compress-html/releases/tag/v1.1.1) layout and put it in your __layout _directory. Then set any root level layout or html file to be based on _compress.html_. For example, our _default.html_ layout includes this front matter: 

{% gist GarthDB/ad5a9f679df5e186c387 %}

#### Adding Tests

The final step to becoming a God of the open blog, is to add automated tests to you public repository. The main goal is just to make sure we know that any new code someone might contribute will not break the Jekyll build process before we even look at the pull request. However, we can also use the opportunity of running tests to check for broken links using the HTML Proofer Library.

This tip comes directly from [Jekyll’s documentation](http://jekyllrb.com/docs/continuous-integration/) on automation, but we’ve tweaked it a bit for DesignOpen. I ended up using [Rake](https://github.com/ruby/rake) to configure and run the test task; this route seems a bit more standard and it makes it easier to run the test locally.

Before you can automate the test, you need to turn on Travis for your repo on your [profile](https://travis-ci.org/profile/).

Next, add a _.travis.yml_ file to your root directory. This configures the test to run.

{% gist GarthDB/9aa03233c220346e0021 %}

Most of this example is self explanitory; the _script_ property is the command that is run, and the _env_ is something that the Jekyll documentation says will speed up the gem installation process of the test. I have no idea if that’s true; I’m just taking it on blind faith.

You also need to create a _:test_ task in your Rakefile. If you aren’t already using Rake, just use something like this:

{% gist GarthDB/f7018996c1eb1475be1a %}

I’m not going to do a deep dive into Rake here, but the important parts are on lines _5_ and _6_. First it builds the Jekyll site, then it uses the [HTML Proofer ](https://github.com/gjtorikian/html-proofer)gem to check all the links in the __site_ directory. Checkout the gem’s [_README.md_](https://github.com/gjtorikian/html-proofer/blob/master/README.md) for the full documentation on the options; I wanted to see where errors occured, so I set _vebose_ to _true_. Also we use a local url in one our articles, so I to ignore that.

The final step is to add the necessary gems to your Gemfile.

{% gist GarthDB/4274823469bc8d8f52ce %}

Use the _:test_ group for the gems that are only necessary for testing the urls.

When it’s all set up correctly, you’ll see a Travis status on every pull request.

![Travis tests](/img/travis_tests_passed.png)

That’s it. If you know of any other way to optimize a GitHub Jekyll site, let me know and I’ll add it to this list.
