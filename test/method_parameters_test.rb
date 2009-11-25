require 'test_helper'

class MethodParametersTest < Test::Unit::TestCase
  context "Method Params" do
    setup do
      @a = A.new(:foo)
    end

    ASSERTIONS = {
      :a =>   [[:req, :a]],
      :b =>   [[:req, :a], [:req, :b]],
      :c =>   [[:req, :a], [:req, :b], [:opt, :c, 1]],
      :d =>   [[:req, :a], [:req, :b], [:opt, :c, "string"], [:rest, :d]],
      :e =>   [[:req, :a], [:rest, :d]],
      :f =>   [[:opt, :a, 1], [:opt, :b, "string"], [:opt, :c, :symbol], [:rest, :d], [:block, :e]],
      :g =>   [[:block, :e]],
      :h =>   [[:rest, :d], [:block, :e]],
      :i =>   [[:rest, :d]],
    }

    context "for instance_method" do
      ("a".."i").each do |method|
        should "get correct parameters from ##{method} method" do
          assert_equal(
            ASSERTIONS[method.to_sym],
            A.instance_method(method.to_sym).parameters
          )
        end
      end
    end

    context "for method" do
      setup do
        @a = A.new(:foo)
      end
      ("a".."i").each do |method|
        should "get correct parameters from ##{method} method" do
          assert_equal(
            ASSERTIONS[method.to_sym],
            @a.method(method.to_sym).parameters
          )
        end
      end
    end

    should "Work on class methods too" do
      assert_equal(
        [[:req, :a], [:opt, :b, 1], [:rest, :c], [:block, :d]],
        A.method(:class_method).parameters
      )
    end
  end
end
