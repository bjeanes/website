class EnkiFormatter
  class << self
    def format_as_xhtml(text)
      InlineCodeFormatter.install
      
      Lesstile.format_as_xhtml(
        text,
        :text_formatter => lambda { |text| RedCloth.new(CGI::unescapeHTML(text)).to_html },
        :code_formatter => CodeFormatter)
    end
    
    def highlight_code(code, lang)
      Uv.parse(CGI::unescapeHTML(code), "xhtml", lang.to_s.downcase, false, "railscasts")
    end
  end
  
  CodeFormatter = lambda { |code, lang|
      lang = lang.to_s.downcase
    
      begin
        code = highlight_code(code, lang)
        code = code.sub(/\A<pre class="[a-zA-Z_-]+">/,%Q[<code data-code-lang="#{lang}"><pre>])
        code = code.sub(/<\/pre>\Z/,'</pre></code>')
      rescue
        code = %Q{<code data-code-lang="#{lang}"><pre>#{code}</pre></code>}
      end

      lines = (1...(code.split(/\n/).size)).to_a.join("\n")
    
      # TODO redo this without tables but stil have line numbers not selectable
      # "<table><caption>#{lang.titleize}</caption><tr><th><pre>#{lines}</pre></th><td>#{code}</td></tr></table>";
      %Q[
          <figure>
            <div>
              <div>
                <pre>#{lines}</pre>
              </div>
              <div>
                #{code}
              </div>
            </div>
          </figure>
        ]
  }
  
  # Inspired by CodeRay.for_redcloth
  module InlineCodeFormatter
    def self.install
      return if @installed
      
      unless Object.const_defined? 'RedCloth'
        gem 'RedCloth', '= 4.1.1' rescue nil
        require 'redcloth'
      end
        
      raise 'InlineCodeFormatter needs RedCloth 4.1.1.' unless RedCloth::VERSION.to_s == '4.1.1'
      
      RedCloth::Formatters::HTML.module_eval do
        def unescape(html)
          replacements = {
            '&amp;' => '&',
            '&quot;' => '"',
            '&gt;' => '>',
            '&lt;' => '<',
          }
          html.gsub(/&(?:amp|quot|[gl]t);/) { |entity| replacements[entity] }
        end
        
        undef_method :code
        
        def code(opts)  # :nodoc:
          opts[:block] = true
          if opts[:lang]
            highlighted_code = EnkiFormatter.highlight_code(opts[:text], opts[:lang])
            highlighted_code.sub!(/\A<pre.*?>/, "<code#{pba(opts)}>")
            highlighted_code.sub!(/[\r\n\s]*<\/pre>\Z/, '</code>')
            highlighted_code = unescape(highlighted_code)
            highlighted_code
          else
            "<code#{pba(opts)}>#{opts[:text]}</code>"
          end
        end
      end
      
      @installed = true
    end
  end
end
