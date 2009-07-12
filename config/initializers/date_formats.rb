ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :html => lambda { |t|
    t.strftime(%Q{
      <abbr title="%B">%b</abbr> 
      %e<sup>#{t.day.ordinalize.gsub(t.day.to_s,'')}</sup> 
      <abbr title="%Y">'%y</abbr>
      <sub>%l:%M %P</sub>
    }) 
  }
)