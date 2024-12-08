Time.zone = 'US/Pacific'

require 'action_view'

require 'slim/include'
Slim::Engine.set_options(
    tabsize: 2,
    include_dirs: ["#{Dir.pwd}/source/partials"],
    pretty: true,
    shortcut: {
      # rubocop:disable Style/StringHashKeys
      '#' => { attr: 'id' },
      '.' => { attr: 'class' },
      '&' => { attr: 'role' },
      '@' => { attr: 'href' }
      # rubocop:enable all
    })

page '/*.xml', layout: false

activate :asset_hash

activate(:blog) { |blog|
  blog.default_extension = '.md'
  blog.generate_day_pages = false
  blog.generate_month_pages = false
  blog.generate_year_pages = false
  blog.layout = 'article'
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

require 'lib/artisanal_markdown'
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

config[:css_dir] = 'assets/css'
config[:host] = 'https://artisanalsoftware.com'
config[:images] = 'assets/img'
config[:images_dir] = 'assets/img'
config[:js_dir] = 'assets/js'
config[:layout] = :site
config[:port] = 80
config[:trailing_slash] = false
