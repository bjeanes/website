module TabFu
  module ListHelper
    class List
      def initialize(context, list_id = '__default', options = {})
        @always_link = options.delete(:always_link) || false
        @context = context
        @list_id = list_id.to_s
      end

      def method_missing(tab, name, link = '#', *options)
        options << {} unless options.last == Hash
        options.last[:rel] = (tab.to_s == current_tab.to_s) ? "current" : nil
        link = @context.link_to(name, link, *options)
        "<li>#{link}</li>"
      end

      private
      def current_tab
        @context.controller.instance_variable_get('@__current_tab')[@list_id]
      rescue
        nil
      end
    end
  end
end