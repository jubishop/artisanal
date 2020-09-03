Time.zone = 'US/Pacific'

page '/*.xml', layout: false
page '/*.json', layout: false

activate :blog do |blog|
  blog.default_extension = '.md.erb'
  blog.generate_day_pages = false
  blog.generate_month_pages = false
  blog.generate_year_pages = false
  blog.new_article_template = File.expand_path(
      'templates/article.tt',
      File.dirname(__FILE__))
  blog.sources = 'articles/{title}.html'
  blog.permalink = 'articles/{title}'
  blog.taglink = 'tags/{tag}.html'
  blog.tag_template = 'tags/tag.html'
  blog.paginate = true
end

activate :directory_indexes

config[:css_dir] = 'assets/css'
config[:images] = 'assets/img'
config[:js_dir] = 'assets/js'
config[:port] = 80
config[:trailing_slash] = false
