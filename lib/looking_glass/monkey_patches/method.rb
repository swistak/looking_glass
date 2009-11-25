module BoundAndUnbound
end

if RUBY_VERSION =~ /^1\.8/
  require 'parse_tree'
  module BoundAndUnbound
    def to_sexp
      match = /<Method: (.*)(\#|\.)(.*)>/.match(self.inspect)
      match ||= /<UnboundMethod: (.*)(\#|\.)(.*)>/.match(self.inspect)

      if match
        @name = match[3].to_sym
        if module_method = match[1].match(/\((.*)\)/)
          klass = module_method[1].to_object
        else
          klass = match[1].to_object
        end
        klass = klass.metaclass if match[2] == '.'
        raise "Couldn't determine class from #{self.inspect}" if klass.nil?
        ParseTree.new(false).parse_tree_for_method(klass, @name)
      else
        raise "Can't parse signature: #{self.inspect}"
      end
    end
  
    def parameters
      pr = self.to_sexp[2][1] rescue []
      result = []
      opts = {}
      if pr[1]
        if pr[1][-1] && pr[1][-1].is_a?(Array)
          pr[1].pop[1..-1].each{|f|
            opts[f[1]] = (f[2][0]==:lit || f[2][0]==:str) ? f[2][1] : nil
          }
        end

        result = pr[1][1..-1].map{|prr|
          if prr.to_s[0..0] == "*"
            [:rest, prr.to_s[1..-1].to_sym]
          elsif opts[prr]
            [:opt, prr, opts[prr]]
          else
            [:req, prr]
          end
        }
      end

      result << [:block, pr[2][1]] if pr[2] && pr[2][1]

      result
    end

    def name
      @name ||= (
        match = /<Method: (.*)(\#|\.)(.*)>/.match(self.inspect)
        match ||= /<UnboundMethod: (.*)(\#|\.)(.*)>/.match(self.inspect)
        match[3]
      )
    end
  end
elsif RUBY_VERSION =~ /^1\.9\.1/
  require "methopara"
end

class Method
  include BoundAndUnbound
end

class UnboundMethod
  include BoundAndUnbound
end


