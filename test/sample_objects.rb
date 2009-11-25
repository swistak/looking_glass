
module B
  def a(a); end
  def g(&e); end
end

class C
  def c(a,b,c=1); end
  def d(a,b,c="string",*d); end
end

class A < C
  include B
  def b(a,b);  end
  def e(a,*d); end
  def f(a=1,b="string",c=:symbol,*d, &e); end
  def h(*d, &e); end
  def i(*d); end

  class << self
    def class_method(a,b=1,*c, &d); end
  end

  def initialize(a)

  end
end
