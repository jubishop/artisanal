Time.zone = 'US/Pacific'

page '/*.xml', layout: false
page '/*.json', layout: false

activate :blog do |blog|
  blog.calendar_template = 'calendar.html'
  blog.day_link = "date/{year}/{month}/{day}.html"
  blog.default_extension = '.md.erb'
  blog.month_link = "date/{year}/{month}.html"
  blog.new_article_template = File.expand_path(
    'source/templates/article.tt',
    File.dirname(__FILE__))
  blog.sources = 'articles/{title}.html'
  blog.permalink = 'article/{title}.html'
  blog.taglink = "tag/{tag}.html"
  blog.tag_template = 'tag.html'
  blog.paginate = true
  blog.year_link = "date/{year}.html"
end

config[:css_dir] = 'assets/css'
config[:images] = 'assets/img'
config[:js_dir] = 'assets/js'
config[:port] = 80
config[:trailing_slash] = false
