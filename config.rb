page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

activate :blog do |blog|
  blog.tag_template = 'tag.html'
  blog.calendar_template = 'calendar.html'
end

configure :build do
end
