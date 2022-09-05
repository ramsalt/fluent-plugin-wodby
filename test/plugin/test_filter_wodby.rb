require "helper"
require "fluent/plugin/filter_wodby.rb"

class WodbyFilterTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::WodbyFilter).configure(conf)
  end

  test 'filter' do
    d = create_driver("api_key #{ENV['WODBY_API_KEY']}")
    time = event_time
    d.run do
      d.feed('filter.test', time, { 'kubernetes.namespace_name' => '650241f4-7303-4668-91c7-b8cd1821d81a', 'message' => 'hullo' })
      d.feed('filter.test', time, { 'kubernetes.namespace_name' => 'a3d67f12-8341-4245-87db-ed7a6c856e70', 'message' => 'hullo' })
    end

    assert_equal(2, d.filtered_records.size)
    assert_equal('dfo.no-staging', d.filtered_records[0]['wodby.instance'])
    assert_equal('dfo.no-prod', d.filtered_records[1]['wodby.instance'])
  end
end
