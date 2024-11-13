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
      d.feed('filter.test', time, { 'kubernetes' => {'namespace_name' => '650241f4-7303-4668-91c7-b8cd1821d81a'}, 'message' => 'hullo', 'wodby.node_name' => 'node' })
      d.feed('filter.test', time, { 'kubernetes' => {'namespace_name' => '7ee5d15f-7c3c-4ce8-873e-34b75154f0f4'}, 'message' => 'hullo', 'wodby.node_name' => 'node' })
      d.feed('filter.test', time, { 'kubernetes' => {'namespace_name' => '650241f4-7303-4668-91c7-b8cd1821d81a'}, 'message' => 'hullo', 'wodby.node_name' => 'node' })
      d.feed('filter.test', time, { 'kubernetes' => {'namespace_name' => 'renovate'}, 'message' => 'hullo', 'wodby.node_name' => 'node' })
    end

    assert_equal(4, d.filtered_records.size)
    assert_true(d.filtered_records[0]['wodby']['found'])
    assert_true(d.filtered_records[1]['wodby']['found'])
    assert_true(d.filtered_records[2]['wodby']['found'])
    assert_false(d.filtered_records[3]['wodby']['found'])

    assert_equal('dfono.staging', d.filtered_records[0]['wodby']['instance'])
    assert_equal('dfono.prod', d.filtered_records[1]['wodby']['instance'])
    assert_equal('dfono.staging', d.filtered_records[2]['wodby']['instance'])
    assert_equal('dfo.no - Staging', d.filtered_records[0]['wodby']['instance_title'])
    assert_equal('dfo.no - Prod', d.filtered_records[1]['wodby']['instance_title'])
    assert_equal('node', d.filtered_records[0]['wodby']['node_name'])
    assert_equal('node', d.filtered_records[1]['wodby']['node_name'])
    assert_equal('dfo', d.filtered_records[0]['wodby']['organization'])
    assert_equal('DFØ', d.filtered_records[1]['wodby']['organization_title'])

    assert_nil(d.filtered_records[2]['wodby']['instance_query'])
    assert_nil(d.filtered_records[2]['wodby.node_name'])

    assert_true(d.filtered_records[0]['wodby']['filter'])
    assert_true(d.filtered_records[1]['wodby']['filter'])
    assert_true(d.filtered_records[2]['wodby']['filter'])
  end
end
