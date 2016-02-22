#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'

class HostLogTests < LibTestBase

  test '3F6D7F',
  'log is initially empty' do
    log = HostLog.new(dummy = nil)
    refute log.include? 'anything'
    assert_equal '[]', log.to_s
  end

  # - - - - - - - - - - - - - - -

  test '734E69',
  'log contains inserted message' do
    log = HostLog.new(dummy = nil)
    log << 'something'
    assert log.include? 'something'
    assert_equal '["something"]', log.to_s
  end

end
