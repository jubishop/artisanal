require 'middleman-core/renderers/redcarpet'

class ArtisanalMarkdown < Middleman::Renderers::MiddlemanRedcarpetHTML
  def preprocess(full_document)
    full_document.gsub!(/!iconify\[(.+?)\]/,
                        '<iconify-icon data-icon="\1"></iconify-icon>')
    return full_document
  end

  def block_code(code, language)
    result = super(code, language)
    result.sub!(%r{</div>\s*$}, '<i class="fas fa-copy clipboard"></i></div>')
    return result
  end

  def codespan(code)
    "<span class=\"codespan\"><code>#{code}</code></span>"
  end
end
