---
layout: header-image-post
title:  "What's Wrong with Sass"
date:   2015-10-19 10:21:23
headerimg: /img/not_only_sass.svg
---

At ConvergeSE 2015, I went to [Bermon Painter](https://twitter.com/bermonpainter)'s session, Modular Front-End Development with Sass. I had already seen a Modular CSS with Sass session from [Mina Markham](https://twitter.com/minamarkham) the day before, but I don't miss Bermon's sessions if I can help it. It was a good session; the key for me was this slide:

<div class="image"><a href="https://instagram.com/p/1lryMIBrwI/?taken-by=garthdb"><img src="/img/dogmatic.jpg" alt="Don't Be Dogmatic" style="width:100%;"/></a></div>

Though I didn't go to his session back in 2013, Chris Eppstein also had some great advice that turns out to be along the same lines.

<div class="image"><a href="https://farm4.staticflickr.com/3805/10314245786_b91451c11e_o.jpg"><img src="https://farm4.staticflickr.com/3805/10314245786_b91451c11e_o_d.jpg" alt="Don't be a Sasshole" style="width:100%;"/></a></div>

## The Sass Dogma

This is the real problem I have with [Sass](http://sass-lang.com/). It's not the community, it's not the syntax, it's not even the tech/language though I think it has its flaws too. The problem with Sass is the way we have adopted it and the attitude we have toward other solutions.

Before I dig into Sass too hard I should mention that I love it. I love using it (I'm using it on this [site](https://github.com/GarthDB/garthdb.github.io/tree/master/css)), I love working with people who love it, I love what it has done for preprocessor awareness and adoption, and I love the way it has pushed the limits of CSS. But, we tend to have a dogmatic attachment to it.

### "But I'm not dogmatic."

You probably are.

Why did [Bootstrap](http://getbootstrap.com/) invest energy and time into converting its code base from [Less](http://lesscss.org/) to [Sass](http://v4-alpha.getbootstrap.com/)? Probably because more people use Sass and more people means more potential contributors. It's also an easier sell for teams already using Sass, but it's also probably because people make fun of Less.

Why do we make snide remarks about Less/Stylus/etc, and cheer about Sass? Because we're dicks, especially towards things that aren't part of our identity. If you identify as a Sass developer, you're less likely to have anything nice to say about any other CSS preprocessor.

Honestly, they are not that different. Most likely Sass and Less inspired each other. The majority of the useful functionality is exactly the same. The syntax might be different, but we shouldn't be making tech decisions based on syntax alone. On the pro list for Less, it is a Javascript based tool, the language Front End Developers eat for breakfast.

I'm using Less here as an example, but it could easily be [Stylus](https://learnboost.github.io/stylus/), [Rework](https://github.com/reworkcss/rework), [Myth](http://www.myth.io/), [PostCSS](https://github.com/postcss/postcss), etc.

## So Why Do We Even Use Sass?

The answer to that question is going to be pretty unique to everyone's individual experience, but I think, for the most part, it's probably the first preprocessor many developers used. It became popular quickly with the Rails startup community and respected developers and designers like [Dan Cederholm](http://simplebits.com/) have [written some great resources](http://abookapart.com/products/sass-for-web-designers) on it. On top of that, the community has rallied around it. They've written solid documentation, it has great branding, there's even a whole friggin conference for it (I don't imagine [Stylus](https://learnboost.github.io/stylus/) will be getting a conference any time soon). Sass filled a huge hole in the CSS developer's workflow, and it deserves the praise it receives, but it isn't perfect.

## The Problem with Sass's Tech

[Ruby](https://www.ruby-lang.org/en/). Ruby is the problem. If you're using Ruby with/without Rails for your project, then Sass is your preprocessor. If you're not then you have a huge problem but developers are nothing if not problem solvers.

And we have solved that problem. If you want to use Sass in your non-Ruby project, you have a couple options: you can force Ruby into your project, you can use a port, or you can use some implementation of [LibSass](http://libsass.org/).

### Ruby in your non-Ruby project.

This has its own downsides -- it adds complexity. It means anyone doing even basic CSS will need to make sure they have an environment setup with Ruby, make sure they are using the right versions, and know how to troubleshoot any issues that pop up. If you are not a Ruby shop already, this is an additional thorn in your side.

### Using a port.

This is tedious and not quite sustainable. To maintain a basic port, the project caretakers are required to stay constantly up to date with upcoming changes and matching them so that they are in sync as much as possible. Also, trying to optimize the port for each individual platform's needs is nearly impossible to do. Additionally, bugs are likely to pop out in unique ways.

### Using LibSass

LibSass is a C library of the Sass compiler. As a C library it can be integrated with pretty much all the platforms using the same code base. At first this might seem like the perfect solution: it doesn't require Ruby and it doesn't have separate ports to maintained across all the platforms. But, it actually has some arguably worse side effects.

It turns out it is a port. The Ruby and LibSass versions of the Sass compiler are not in sync, they do not have feature parity. LibSass will have all the struggles associated with being a port. So why not just make the Ruby version based on LibSass? I don't actually know why, but my guess is because it is written in C and most web developers don't need to use C. This is the other big side effect of LibSass. If you want to make a contribution in the form of new features or bug fixes, you have to do it in C.

The power in the plethora of these Front End Developer tools is that they are open source. If something is broken, the community can fix it. If it is lacking a feature, the community can add it. If it needs to go in a different direction, it can be forked. It is in the Front End Developer's best interest to use tools written in a language they are proficient in.

Maybe you're thinking, "yeah, but I don't plan on ever contributing code to the tools I use" and maybe you're a selfish jerk.

**Note**: I've had some interesting conversations with [Chris Eppstein](http://twitter.com/chriseppstein) and other Sass developers who have assured me that the Sass team has a high level of commitment to feature parity between Ruby Sass and LibSass which makes it the best kind of port.

## What's the Solution?

So what should you use? Anything else. I'm not saying that it's time to burn Sass to the ground. I really think we need it but I think we also need to be using other preprocessors as well, or at least playing with them. Don't go abandoning Sass on your day job projects, but next time you start a side project, or a prototype, look at other options. It is good to try new things.

Here are some thoughts to consider:

* Less still has that client side library, so you don't have to compile it to CSS while writing code locally. It's super weird and arguably useless, but still interesting.
* Stylus is stupid terse and forgiving. Throw CSS in there and it works. Forget semicolons or even colons and braces, it still works. Technically speaking it should use the least number of characters to write so it could be the fastest syntax to type.
* Rework and PostCSS use plugins to let you pick and choose the functionality you want, or even write new features without forking the codebase. Also, they are [super fast](http://ai.github.io/about-postcss/en/#42), and there are a bunch of things they can do that are impossible with Sass, like [Autoprefixer](https://github.com/postcss/autoprefixer), which blows [Compass](http://compass-style.org/) out of the water.
* The CSS spec is progressing to add a lot of the features we use preprocessors to achieve. One day we may not need any preprocessor, but until then you can [cssnext](http://cssnext.io/) as a polyfill. Future CSS, today!
* Write some vanilla CSS once in a while, it's good for you.

Reading this, you might assume I'm a PostCSS or even Stylus fanboy, and you'd be 100% correct, but I'm not so delusional as to think they will be my favorite tools in the future. My goal is to keep playing and to keep trying to push the limits of this workflows into interesting and useful directions.
