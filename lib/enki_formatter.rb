class EnkiFormatter
  class << self
    def format_as_xhtml(text)
      Lesstile.format_as_xhtml(
        text,
        :text_formatter => lambda { |text| RedCloth.new(CGI::unescapeHTML(text)).to_html },
        :code_formatter => lambda { |code, lang|
            lang = lang.to_s.downcase
          
            begin
              code = Uv.parse(CGI::unescapeHTML(code), "xhtml", lang.to_s.downcase, false, "railscasts")
              code = code.gsub(/^<pre class="[a-zA-Z_-]+">/,%Q[<code lang="#{lang}"><pre>])
              code = code.gsub(/<\/pre>$/,'</pre></code>')
            rescue
              code = %Q{<code lang="#{lang}"><pre>#{code}</pre></code>}
            end

            lines = (1...(code.split(/\n/).size)).to_a.join("\n")
          
            "<table><caption>#{lang.titleize}</caption><tr><th><pre>#{lines}</pre></th><td>#{code}</td></tr></table>"
        }
      )
    end
  end
end
