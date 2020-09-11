---
title: Using Erb with Jekyll
date: 2020-09-08 18:28 PDT
tags: erb, ruby
---

My initial plan for this blog was to use [Jekyll](https://jekyllrb.com).  After all: it seems to be the most popular choice.  But I quickly grew frustrated with the limitations of [Liquid](https://shopify.github.io/liquid/).  I wanted to use [Erb](https://ruby-doc.org/stdlib-2.7.1/libdoc/erb/rdoc/ERB.html), which is far more powerful and familiar.

But from everything I could find: Erb was not an option.  The primary explanation seems to be that it's unsafe because it allows for the arbitrary execution of Ruby, which would be unacceptable to Jekyll's two largest customers:  [Github](http://github.com) and [Shopify](http://shopify.com).  Most threads would lead to suggesting [jekyll-rendering](https://github.com/prometheus-ev/jekyll-rendering), which seemed promising, but it hasn't been updated in 6 years and no longer works with modern versions of Jekyll.

Welp, one of the great and terrifying things about Ruby is that anything can be modified.   No library code is safe from an unscrupulous developer willing to do unholy things.  I decided the method `Jekyll::Renderer::render_liquid`, found [here](https://github.com/jekyll/jekyll/blob/master/lib/jekyll/renderer.rb), was the optimal place to cut in some Erb action.  The function is universally called anytime Jekyll wants to parse a string with Liquid.  What's better: it's passed all the juicy [local variables](https://jekyllrb.com/docs/variables/) intended for use inside Liquid tags.  We could hijack this function and process the string with Erb, passing along the same local variables.

## Thusly, the plan was hatched.

There are several approaches to monkey-patching an existing function.  I believe the cleanest is to create a new Module, then open the existing class and insert it via the `prepend` operator.  Since this is a shameful thing to do, I didn't think this deserved to be made into its own gem, so I simply added a file to the `./plugins` directory inside my project.  I threw in the [recursive-open-struct](https://github.com/aetherknight/recursive-open-struct) gem to make things slicker.  I didn't want to lose access to any other plugin or gem available for Jekyll that might use Liquid, so rather than stop Liquid processing entirely, I decided I'd do both: first Liquid, then Erb.  This would be the equivalent of a file in [Middleman](https://middlemanapp.com) with the extension `.liquid.erb`.  Behold, the hack in its entirety:

```ruby
require 'erb'
require 'recursive-open-struct'

module EmbeddedRuby
  def render_liquid(content, payload, info, path = nil)
    liquid = super(content, payload, info, path)

    site = RecursiveOpenStruct.new(payload.site.to_h,
                                   recurse_over_arrays: true)
    page = RecursiveOpenStruct.new(payload.page,
                                   recurse_over_arrays: true)
    layout = RecursiveOpenStruct.new(payload.layout,
                                     recurse_over_arrays: true)
    content = payload.content
    paginator = RecursiveOpenStruct.new(payload.paginator,
                                        recurse_over_arrays: true)

    return ERB.new(liquid).result(binding)
  end
end

module Jekyll
  class Renderer
    prepend EmbeddedRuby
  end
end
```

As an example, in the Jekyll tutorial, there's some code for [how to build a nav](https://jekyllrb.com/docs/step-by-step/06-data-files/) that uses liquid like this:

```liquid
<nav>
  {% for item in site.data.navigation %}
    <a href="{{ item.link }}"
       {% if page.url == item.link %}style="color: red;"{% endif %}>
      {{ item.name }}
    </a>
  {% endfor %}
</nav>
```

This could now be expressed in Erb instead as:

```erb
<nav>
  <% site.data.navigation.each { |item| %>
    <a href="<%= item.link %>"
       <% if page.url == item.link %>style="color: red;"<% end %>>
      <% item.name %>
    </a>
  <% } %>
</nav>
```

This is not, on the face of it, much prettier.  In order to really make headway, we'd want to pull in [Padrino](http://padrinorb.com) to support helpers like `link_to`.

This is, in general, a bad idea, because **the function `render_liquid` is not part of any interface contract between Jekyll and its users**.  The function could be changed out from under us at any time, breaking our modification.  A hack like this might be justified if you're already deeply entrenched into Jekyll with a well established project that needs Erb support.

[Middleman](https://middlemanapp.com) ultimately proved a much better choice for this blog.  But since I could tell I wasn't the only person interested in using Erb with Jekyll, I thought this was a hack worth sharing.  If you've found other ways to incorporate Erb with Jekyll, hit me up!  I'd be curious to know.
