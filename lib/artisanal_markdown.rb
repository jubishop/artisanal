require 'middleman-core/renderers/redcarpet'

class ArtisanalMarkdown < Middleman::Renderers::MiddlemanRedcarpetHTML
  def preprocess(full_document)
    full_document.gsub!(/!iconify\[(.+?)\]/,
                        '<iconify-icon data-icon="\1"></iconify-icon>')
  end

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
