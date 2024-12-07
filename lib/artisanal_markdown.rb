require 'English'
require 'middleman-core/renderers/redcarpet'

require_relative 'artisanal_slim'

class ArtisanalMarkdown < Middleman::Renderers::MiddlemanRedcarpetHTML
  def preprocess(full_document)
    # Iconify
    full_document.gsub!(/!iconify\[(.+?)\]/,
                        '<iconify-icon icon="\1"></iconify-icon>')

    # Font-Awesome
    full_document.gsub!(/!fa([bdls])\[(.+?)\]/, '<i class="fa\1 fa-\2"></i>')

    # Fancy inline code
    full_document.gsub!(/(?<language>[a-z]+)\|`(?<code>.+?)`\|/) {
      inline_code($LAST_MATCH_INFO[:code], $LAST_MATCH_INFO[:language])
    }

    return full_document
  end

  def block_code(code, language)
    return "<pre class=\"mermaid\">#{code}</pre>" if language == 'mermaid'

    result = super(code, language)
    result.sub!(%r{</div>\s*$}, '<i class="fas fa-copy clipboard"></i></div>')
    return result
  end

  private

  def inline_code(code, language)
    formatter = Rouge::Formatters::HTML.new
    lexer = Rouge::Lexer.find_fancy(language, code)
    formatted = formatter.format(lexer.lex(code))

    formatted.gsub!('_', '\_') # Escape markdown crap

    return Slim.render(<<~SLIM, binding)
      span.highlight
        code
          ==formatted
    SLIM
  end
end
