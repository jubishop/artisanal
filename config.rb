Time.zone = 'US/Pacific'

page '/*.xml', layout: false
page '/*.json', layout: false

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
  blog.summary_separator = /READMORE/
  blog.taglink = 'tags/{tag}.html'
  blog.tag_template = 'tag.html'
  blog.paginate = true
}

activate :directory_indexes
activate :syntax

config[:css_dir] = 'assets/css'
config[:images] = 'assets/img'
config[:images_dir] = 'assets/img'
config[:js_dir] = 'assets/js'
config[:host] = 'https://artisanalsoftware.com'
config[:markdown] = {fenced_code_blocks: true, smartypants: true}
config[:markdown_engine] = :redcarpet
config[:partials_dir] = 'partials'
config[:port] = 80
config[:trailing_slash] = false
