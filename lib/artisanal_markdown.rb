require 'middleman-core/renderers/redcarpet'

class ArtisanalMarkdown < Middleman::Renderers::MiddlemanRedcarpetHTML
  def block_code(code, language)
    result = super(code, language)
    if result[-6..] == '</div>'
      result[0...-6] + '<i class="fas fa-copy clipboard"></i>' + result[-6..]
    else
      result
    end
  end

  def codespan(code)
    '<span class="codespan"><code>' + code + '</code></span>'
  end
end
