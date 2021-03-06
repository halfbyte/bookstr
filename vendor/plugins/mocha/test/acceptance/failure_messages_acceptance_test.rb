require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha'
require 'test_runner'

class FailureMessagesAcceptanceTest < Test::Unit::TestCase
  
  OBJECT_ADDRESS_PATTERN = '0x[0-9A-Fa-f]{1,12}'
  
  include TestRunner
  
  class Foo; end
  
  def test_should_display_class_name_when_expectation_was_on_class
    test_result = run_test do
      Foo.expects(:bar)
    end
    assert_match Regexp.new('^FailureMessagesAcceptanceTest::Foo'), test_result.failures[0].message
  end
  
  def test_should_display_class_name_and_address_when_expectation_was_on_instance
    test_result = run_test do
      Foo.new.expects(:bar)
    end
    assert_match Regexp.new("^#<FailureMessagesAcceptanceTest::Foo:#{OBJECT_ADDRESS_PATTERN}>"), test_result.failures[0].message
  end
  
  def test_should_display_class_name_and_any_instance_prefix_when_expectation_was_on_any_instance
    test_result = run_test do
      Foo.any_instance.expects(:bar)
    end
    assert_match Regexp.new('^#<AnyInstance:FailureMessagesAcceptanceTest::Foo>'), test_result.failures[0].message
  end
  
  def test_should_display_mock_name_when_expectation_was_on_named_mock
    test_result = run_test do
      foo = mock('foo')
      foo.expects(:bar)
    end
    assert_match Regexp.new('^#<Mock:foo>'), test_result.failures[0].message
  end
  
  def test_should_display_mock_address_when_expectation_was_on_unnamed_mock
    test_result = run_test do
      foo = mock()
      foo.expects(:bar)
    end
    assert_match Regexp.new("^#<Mock:#{OBJECT_ADDRESS_PATTERN}>"), test_result.failures[0].message
  end
  
  def test_should_display_string_when_expectation_was_on_string
    test_result = run_test do
      'Foo'.expects(:bar)
    end
    assert_match Regexp.new("'Foo'"), test_result.failures[0].message
  end
  
end