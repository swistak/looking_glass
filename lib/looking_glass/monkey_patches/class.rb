class Class
  def metaclass
    class << self
      self
    end
  end

  def published(*args)
    if args.empty?
      public
      @_published_scope = true
    else
      methods = args.map{|a| a.to_sym}
      @published_methods.merge(methods)
      public(*methods)
    end
  end

  def method_added(method)
    @published_methods.add(method) if @_published_scope
  end

  def instance_published_methods
    @published_methods.to_a
  end
end