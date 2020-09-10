module HeadHelpers
  def font_awesome(kit_id)
    javascript_include_tag("https://kit.fontawesome.com/#{kit_id}.js",
                           crossorigin: :anonymous)
  end

  def google_fonts(*fonts)
    families = fonts.map { |font| "family=#{font}" }.join('&')
    stylesheet_link_tag("https://fonts.googleapis.com/css2?#{families}&" \
                        'display=swap')
  end
end
