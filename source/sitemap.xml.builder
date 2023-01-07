xml.instruct!
xml.urlset(xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9') {
  sitemap.resources.each { |resource|
    next if resource.url.match?(/\.(css|js|png|jpg|jpeg|gif)$/)

    xml.url {
      xml.loc(URI.join(config[:host], resource.url))
    }
  }
}
