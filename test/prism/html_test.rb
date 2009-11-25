require 'test_helper'

class PrismHtmlTest < Test::Unit::TestCase
  context Prism::Html do
    setup do
      @prism = Prism::Html.new
      Prism::Html::SERIALIZERS[Object] = lambda do |o|
        raise TypeError, "We got object, not good, here are ancestors: #{o.metaclass.ancestors.inspect}"
      end
    end

    should "serialize string" do
      assert_equal '<span class="string enumerable comparable">foo &amp; bar</span>', @prism.serialize("foo & bar")
    end

    should "serialize array" do
      assert_equal('<ol class="array enumerable"><li>1</li><li>2</li></ol>', @prism.serialize([1,2]))
    end

    should "serialize hash" do
      assert_equal('<dl class="hash enumerable"><dt><em class="symbol">a</em></dt><dd>1</dd></dl>', @prism.serialize({:a => 1}))
    end

    should "serialize symbol" do
      assert_equal '<em class="symbol">foo_bar</em>', @prism.serialize(:foo_bar)
    end

    should "serialize method" do
      assert_equal '
        <form action="f" class="method" method="post">
           <fieldset class="attributes">
             <label for="a">a</label>
             <input class="req" name="a" value="" />
             <label for="b">b</label>
             <input class="opt" name="b" value="string" />
             <label for="c">c</label>
             <input class="opt" name="c" value="symbol" />
             <label for="d">d</label>
           </fieldset>
           <fieldset class="rest">
             <input class="rest" name="d" value="" />
           </fieldset>
           <fieldset class="buttons">
             <submit class="submit" name="f" value="f" />
           </fieldset>
         </form>
      '.gsub(/[ ]*\n[ ]*/, ''), @prism.serialize(A.instance_method(:f))
    end
  end
end