xml.instruct!
xml.rss(version: '2.0') {
  xml.channel {
    xml.title('Artisanal Software')
    xml.description('A Blog about Code')
    xml.link(URI.join(config[:host], blog.options.prefix.to_s))
    xml.pubDate(blog.articles.first.date.rfc822)
    blog.articles[0..5].each { |article|
      xml.item {
        xml.title(article.title)
        xml.link(URI.join(config[:host], article.url))
        xml.description(article.body)
        xml.author('jubi@jubishop.com')
        xml.pubDate(article.date.rfc822)
        xml.guid(URI.join(config[:host], article.url))
      }
    }
  }
}
