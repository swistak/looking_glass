Object.class_eval do
  def metaclass
    case self
    when Symbol, Fixnum, true, false, nil
      self.class
    else
      class << self
        self
      end
    end
  end

  def published_methods
    metaclass.instance_published_methods
  end
end