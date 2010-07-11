class EnkiFormatter
  class << self
    def format_as_xhtml(text)
      InlineCodeFormatter.install
      
      Lesstile.format_as_xhtml(
        text,
        :text_formatter => lambda { |text| RedCloth.new(CGI::unescapeHTML(text)).to_html },
        :code_formatter => CodeFormatter)
    end
    
    def highlight_code(code, lang="plain_text", theme="railscasts")
      Uv.parse(CGI::unescapeHTML(code), "xhtml", lang.to_s.downcase, false, theme)
    rescue NoMethodError
      Uv.parse(CGI::unescapeHTML(code), "xhtml", "plain_text", false, theme)
    end
  end
  
  # Surrounds each line of code in the <pre> with <code> blocks
  CodeFormatter = lambda { |code, lang|
      code = highlight_code(code, lang)
      open, code, close = code.scan(/\A(<pre class="[^"]+">)(.*)(<\/pre>)\Z/m).flatten
      code = code.split(/\n/).map{|line| "<code data-code-lang=\"#{lang}\">#{line}</code>"}.join("\n")
      "#{open}#{code}#{close}"
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
            '&amp;'  => '&',
            '&quot;' => '"',
            '&gt;'   => '>',
            '&lt;'   => '<',
          }
          html.gsub(/&(?:amp|quot|[gl]t);/) { |entity| replacements[entity] }
        end
        
        undef_method :code
        
        def code(opts)  # :nodoc:
          opts[:block] = true
          
          if opts[:lang]
            highlighted_code = EnkiFormatter.highlight_code(opts[:text], opts[:lang])
            highlighted_code.sub!(/\A<pre.*?>/, %Q{<code data-code-lang="#{opts[:lang]}">})
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
