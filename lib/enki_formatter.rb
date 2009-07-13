class EnkiFormatter
  class << self
    def format_as_xhtml(text)
      Lesstile.format_as_xhtml(
        text,
        :text_formatter => lambda { |text| RedCloth.new(CGI::unescapeHTML(text)).to_html },
        :code_formatter => lambda { |code, lang| 
          lang = lang.to_s.downcase
          
          code = Uv.parse(CGI::unescapeHTML(code), "xhtml", lang.to_s.downcase, false, "railscasts")
          code = code.gsub(/^<pre class="[a-zA-Z_-]+">/,%Q[<code lang="#{lang}"><pre>])
          code = code.gsub(/<\/pre>$/,'</pre></code>')

          lines = (1...(code.split(/\n/).size)).to_a.join("\n")
          
          "<table><caption>#{lang.titleize}</caption><tr><td><pre>#{lines}</pre></td><td>#{code}</td></tr></table>"
        }
      )
    end
  end
end
