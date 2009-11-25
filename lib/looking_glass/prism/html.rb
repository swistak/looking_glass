require 'cgi'
require 'pp'

module Prism
  class Html
    SERIALIZERS = {}

    def initialize
      SERIALIZERS.replace({
          Hash => lambda do |o|
            tag('dl', attributes_for(o), o.map{|k,v|
                tag('dt', {}, serialize(k))+
                  tag('dd', {}, serialize(v))
              }.join)
          end,
          Array => lambda do |o|
            tag('ol', attributes_for(o), o.map{|e|
                tag('li', {}, serialize(e))
              }.join)
          end,
          Set => lambda do |o|
            tag('ul', attributes_for(o), o.map{|e|
                tag('li', {}, serialize(e))
              }.join)
          end,
          String => lambda do |o|
            tag('span', attributes_for(o), escape(o))
          end,
          Symbol => lambda do |o|
            tag('em', attributes_for(o), escape(o.to_s))
          end,
          Integer => lambda do |o|
            o.to_s
          end,
          BoundAndUnbound => lambda do |o|
            tag('form', :action => o.name, :class => 'method', :method => 'post') do
              o.parameters.map{|type, name, default_value|
                tag("label", {:for => name}, name) +
                  tag("input", {
                    :class => type,
                    :value => default_value.to_s,
                    :name  => name
                  })
              }.join + 
                tag("submit", :name => o.name, :value => o.name, :class => 'submit')
            end
          end,
          Object => lambda do |o|
            escape(o.to_s)
          end

        })
    end

    def serialize(object)
      ancestors = object.metaclass.ancestors
      ancestors.each do |a|
        if serializer = SERIALIZERS[a]
          return serializer.call(object)
        end
      end
    end

    def sanitize(name)
      name.to_s.gsub("::", "-").gsub(/[^-_\w]/, '').downcase
    end

    def escape(string)
      CGI.escapeHTML(string)
    end

    def tag(name, attributes={}, content=nil, &block)
      name = sanitize(name)
      content ||= block && ((block.arity == 0) ? block.call : block.call(self))
      content = content.to_s
      attributes = attributes.sort_by{|k,v| k.to_s}.map{|k,v|
        "#{sanitize(k)}=\"#{v.to_s.gsub('"', '\"')}\""
      }.join(" ")

      # TODO: check for mandatory content for some tags? mayby require no content for some?
      content.empty? ? "<#{(name+" "+attributes).strip} />" : "<#{(name+" "+attributes).strip}>#{content}</#{name}>"
    end
    
    def attributes_for(object)
      ancestors = object.metaclass.ancestors
      html_class = (ancestors - Object.ancestors).map{|a| 
        sanitize(a.to_s)
      }.join(" ")
      
      { :class => html_class }
    end
  end
end