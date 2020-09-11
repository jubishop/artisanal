xml.instruct!
xml.feed(xmlns: 'http://www.w3.org/2005/Atom') {
  xml.title 'Artisanal Software'
  xml.id URI.join(config[:host], blog.options.prefix.to_s)
  xml.link href: URI.join(config[:host], blog.options.prefix.to_s)
  xml.link href: URI.join(config[:host], current_page.path), rel: 'self'
  unless blog.articles.empty?
    xml.updated(blog.articles.first.date.iso8601)
  end
  xml.author {
    xml.name 'Justin Bishop'
    xml.email 'jubi@jubishop.com'
  }

  blog.articles[0..5].each { |article|
    xml.entry {
      xml.title article.title
      xml.link href: URI.join(config[:host], article.url), rel: 'alternate'
      xml.id URI.join(config[:host], article.url)
      xml.published article.date.iso8601
      xml.updated File.mtime(article.source_file).iso8601
      xml.author {
        xml.name 'Justin Bishop'
        xml.email 'jubi@jubishop.com'
      }
      xml.summary article.summary, type: 'html'
      xml.content article.body, type: 'html'
    }
  }
}
