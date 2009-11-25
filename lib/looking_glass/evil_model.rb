class ValidationError < RuntimeError; end

module MustBe
  @@validation_rules ||= []
  
  def backrack_validate
    @@validation_rules.each do |rule, options|
      result = if rule.respond_to? :call
        rule.call(self)
      elsif rule.kind_of? Symobl
        self.send(rule)
      end
      unless result
        ex = options[:exception] || ValidationError
        msg = options[:message] || "Validation #{rule} failed"
        raise(ex, msg, caller)
      end
    end
    
    if self.respond_to? :validate
      self.send(:validate)
    end
  end
  
  def valid?
    !!backrack_validate
  rescue ValidationError
    false
  end
  
  def self.must_be(condition, options={})
    @@validation_rules << [condition, options]
  end  
  
  # i think order is important here :)
  # that thing bellow is to evil, even for me, but i did it anyways :D
  def self.method_added(method)
    m = ParseTree.translate(self, method)
    fun_sexp = [:fcall, :backrack_validate]
    m[2][1].insert(2, fun_sexp)
    self.class_eval(Ruby2Ruby.new.process(m))
  end
end