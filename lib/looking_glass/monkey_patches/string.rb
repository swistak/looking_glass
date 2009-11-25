class String
  unless "String".respond_to? :to_object
    def to_object
      self.split("::").inject(Object){|result, constant| result.const_get(constant)}
    end
  end

  def camelize(upcase_first_letter=true)
    # camelcase from ruby facets
    up = upcase_first_letter
    str = dup
    str.gsub!(/\/(.?)/){ "::#{$1.upcase}" }  # NOT SO SURE ABOUT THIS -T
    str.gsub!(/(?:_+|-+)([a-z])/){ $1.upcase }
    str.gsub!(/(\A|\s)([a-z])/){ $1 + $2.upcase } if up
    str
  end
  
  def underscore
    self.split('::').map do |s|
      s.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").downcase
    end.join('::')
  end
  
  def camelize!
    replace camelize
  end
  
  def underscore!
    replace underscore
  end
end
