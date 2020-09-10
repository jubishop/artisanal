Time.zone = 'US/Pacific'

require 'lib/artisanal_markdown'

Slim::Engine.set_options(
  tabsize: 2,
  include_dirs: ['./source/partials'],
  pretty: true,
  shortcut: {
    '#' => { attr: 'id' },
    '.' => { attr: 'class' },
    '@' => { attr: 'role' }
  })

page '/*.xml', layout: false

activate(:blog) { |blog|
  blog.default_extension = '.md.erb'
  blog.generate_day_pages = false
  blog.generate_month_pages = false
  blog.generate_year_pages = false
  blog.layout = 'article'
  blog.new_article_template = File.expand_path(
      'templates/article.tt',
      File.dirname(__FILE__))
  blog.permalink = 'articles/{title}'
  blog.sources = 'articles/{title}.html'
  blog.summary_separator = /\n+/
  blog.taglink = 'tags/{tag}.html'
  blog.tag_template = 'tag.html'
  blog.paginate = true
}

activate :directory_indexes

activate(:syntax) { |syntax|
  syntax.css_class = ''
}

config[:css_dir] = 'assets/css'
config[:host] = 'https://artisanalsoftware.com'
config[:images] = 'assets/img'
config[:images_dir] = 'assets/img'
config[:js_dir] = 'assets/js'
config[:layout] = :main
config[:markdown] = {
  autolink: true,
  fenced_code_blocks: true,
  footnotes: true,
  highlight: true,
  quote: true,
  renderer: ArtisanalMarkdown,
  smartypants: true,
  space_after_headers: true,
  strikethrough: true,
  superscript: true,
  underline: true
}
Slim::Embedded.options[:markdown] = config[:markdown]
config[:markdown_engine] = :redcarpet
config[:port] = 80
config[:trailing_slash] = false
