---
title: Pimping out middleman-syntax
date: 2020-09-12 21:41 PDT
tags: middleman, ruby, blog
---

Let's talk about how to set up [middleman-syntax](https://github.com/middleman/middleman-syntax) and then about some stuff I've added on top for this blog.  First thing's first, of course you need to:

- sh|`gem install middleman-syntax`|
- add `gem 'middleman-syntax'` to your sh|`Gemfile`|
- sh|`bundle update`|
- sh|`bundle install`|

## Markdown

I like to write my articles in straight [Markdown](https://daringfireball.net/projects/markdown/).  It's clean that way.  So this tutorial is specifically about enabling [fenced code blocks](https://www.markdownguide.org/extended-syntax/#fenced-code-blocks), which you can see in action, for example, in the markup for this [specific article on github](https://github.com/jubishop/artisanal/blob/master/source/articles/pimping-out-middleman-syntax.html.md).

## Redcarpet

I recommend using [RedCarpet](https://github.com/vmg/redcarpet) as your Markdown renderer.  There's a lot of cool configuration options for customizing your Markdown setup.  Below I'm just showing the specific ones needed in your sh|`config.rb`| to enable the features I'm going to discuss:

```ruby
activate(:syntax) { |syntax|
  syntax.css_class = ''
}

require 'lib/artisanal_markdown'
config[:markdown] = {
  fenced_code_blocks: true,
  renderer: ArtisanalMarkdown,
}
config[:markdown_engine] = :redcarpet
```

## Rouge

[Rouge](http://rouge.jneen.net) is great for both lexing your code into different html|`span`| elements and applying CSS themes that will automatically highlight those elements.  Since this blog supports both dark and light modes, I chose a different theme that looked good for both scenarios and put them in different files.  I created sh|`dark_syntax.css.slim`| and filled it with just this one line:

```slim
==Rouge::Themes::MonokaiSublime.render(:scope => '.highlight')
```

When [middleman](https://middlemanapp.com) builds everything, this'll get expanded to all the fancy CSS for colorizing our code in dark mode.  I'm using the excellent template language [Slim](http://slim-lang.com), but if you were using [Erb](https://ruby-doc.org/stdlib/libdoc/erb/rdoc/ERB.html), the file would be named sh|`dark_syntax.css.erb`| and the line would be:

```erb
<%= Rouge::Themes::MonokaiSublime.render(:scope => '.highlight') %>
```

I also created sh|`light_syntax.css.slim`| and inserted:

```slim
==Rouge::Themes::Github.render(:scope => '.highlight')
```

So now we have a CSS file for both light and dark mode syntax highlighting.  Next, at the top of sh|`article.css`|, which is included in every article page, I put:

```css
/* ROUGE THEMES */
@import url('/assets/css/light_syntax.css');
@import url('/assets/css/dark_syntax.css') (prefers-color-scheme: dark);
```

And voilá, we have the CSS we need to colorize things.

## Some basic CSS tweaks

[middleman-syntax](https://github.com/middleman/middleman-syntax) will automatically wrap your code-blocks in html|`<code>`| tags.  Browsers will convert this to a default monospace font, but I specifically like [Fira Code](https://fonts.google.com/specimen/Fira+Code), so I added:

```css
code {
  font-family: 'Fira Code', monospace;
}
```

I also wanted to modify the padding around each block a bit and position it with css|`position: relative`|.  Each block gets wrapped in html|`<div class="highlight"><pre>`| so:

```css
div.highlight {
  margin: 0;
  padding: 0.6em;
  position: relative;
}
div.highlight pre {
  margin: 0;
}
```

## Displaying the language

One thing I always like about [CSS-TRICKS](https://css-tricks.com) is how they display the language of any code block in the upper right corner.  I wanted to add the same, but as seamlessly and effortlessly as possible.  When creating a code block you're supposed to put the language right after the triple backticks, so the Lexer can parse it accurately.  My goal was to reuse that language identifier directly and just put it in the upper right corner.  In sh|`config.rb`| I remove any additional classes that might otherwise be applied to the wrapping html|`<pre>`| tag by saying `syntax.css_class = ''`.  We don't actually need any extra classes there, because the whole thing is also wrapped in a html|`<div class="highlight">`|, which is all our CSS selectors need.  This means our html|`<pre>`| tags will only have the class of our language, i.e. html|`<pre class="ruby">`|.  Boom.  Now we can reuse that html|`"class"`| attribute for the content of a pseudo-element in CSS.  We also want to position it tightly into the upper right corner.  The magic sauce becomes:

```css
div.highlight pre::before {
  color: var(--dim-text-color);
  content: attr(class);
  font-family: var(--cursive-font), cursive;
  font-size: 0.8em;
  position: absolute;
  right: 0.3em;
  top: -0.3em;
}
```

## Adding a click to copy button

The second thing I really wanted to add was a little clickable icon in the bottom right which would copy the code block to the reader's clipboard.  I can't use another pseudo-element for this task, because I need to attach a javascript|`click`| event listener, and those can't be applied to pseudo-elements.  Instead, I tweak the Markdown renderer to add an extra html|`<div>`| to the bottom of every code block.  This brings us to the class `ArtisanalMarkdown`, which I pull into the sh|`config.rb`| file via ruby|`require lib/artisanal_markdown`|, and then I specify for use with the ruby|`renderer: ArtisanalMarkdown`| assignment inside the ruby|`config[:markdown]`| hash.  The parts of the class used for this modification look like this:

```ruby
require 'middleman-core/renderers/redcarpet'

class ArtisanalMarkdown < Middleman::Renderers::MiddlemanRedcarpetHTML
  def block_code(code, language)
    result = super(code, language)
    result.sub!(%r{</div>\s*$}, '<i class="fas fa-copy clipboard"></i></div>')
    return result
  end
end
```

What this is doing is: calling the super class to do it's normal thing, then, right before the closing html|`</div>`|, injecting a slick little icon from [Font Awesome](https://fontawesome.com/icons/copy).  Let's position our injected icon element in the bottom right corner, and set the css|`cursor`| to be css|`copy`| as a hint to the user of what it does.  Let's also make it change color when the mouse rolls over it and clicks it:

```css
.clipboard {
  bottom: 0.2em;
  color: var(--dim-text-color);
  cursor: copy;
  position: absolute;
  right: 0.2em;
}
.clipboard:hover {
  color: var(--text-color);
}
.clipboard:active:hover {
  color: var(--link-color);
}
```

Now we just have to add a javascript|`click`| event listener to every instance of the css|`clipboard`| class.  It used to be a really ugly hack to inject something into a user's clipboard via Javascript, but we live in a golden age of browsers where javascript|`navigator.clipboard.writeText()`| actually works.  We just have to extract the javascript|`textContent`| from the code block and pass it onward.  The entirety of the code to make this work is:

```javascript
// Copying code blocks to the clipboard.
document.addEventListener('DOMContentLoaded', () => {
  const clipboards = document.getElementsByClassName('clipboard');
  for (let clipboard of clipboards) {
    clipboard.addEventListener('click', (event) => {
      const code = event.target.previousSibling.textContent.trim();
      navigator.clipboard.writeText(code);
    });
  }
});
```

And there you have it!  You needn't look further than all the code blocks on this page to see the end result.

## CSS variables

As a final note: several of the CSS examples I have shown are using [CSS variables](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties), such as css|`var(--dim-text-color)`|.  I leave it as an exercise to the reader to define these in their own CSS files however they like.
