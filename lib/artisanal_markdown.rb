require 'middleman-core/renderers/redcarpet'
require 'rouge'

class ArtisanalMarkdown < Middleman::Renderers::MiddlemanRedcarpetHTML
  def preprocess(full_document)
    # Iconify
    full_document.gsub!(/!iconify\[(.+?)\]/,
                        '<iconify-icon data-icon="\1"></iconify-icon>')

    # Fancy inline code
    formatter = Rouge::Formatters::HTML.new
    full_document.gsub!(/(?<language>[a-z]+)\|`(?<code>.+?)`\|/) {
      inline_code($~[:code], $~[:language])
    }

    return full_document
  end

  def block_code(code, language)
    result = super(code, language)
    result.sub!(%r{</div>\s*$}, '<i class="fas fa-copy clipboard"></i></div>')
    return result
  end

  def codespan(code)
    return inline_code(code, 'ruby')
  end

  private

  def inline_code(code, language)
    formatter = Rouge::Formatters::HTML.new
    lexer = Rouge::Lexer.find_fancy(language, code)
    formatted = formatter.format(lexer.lex(code))
    return "<span class=\"highlight\"><code>#{formatted}</code></span>"
  end
end
