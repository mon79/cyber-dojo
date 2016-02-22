#!/bin/bash ../test_wrapper.sh

require_relative './app_models_test_base'

class LightsTests < AppModelsTestBase

  test '881D3F',
  'lights initially empty' do
    kata = make_kata
    lights = kata.start_avatar.lights
    assert_equal [], lights.to_a
    assert_equal 0, lights.count
    n = 0
    lights.each { n += 1 }
    assert_equal 0, n
  end

  #- - - - - - - - - - - - - - - - - - -

  test 'D1106F',
  'lights not empty' do
    kata = make_kata
    puffin = kata.start_avatar(['puffin'])
    maker = DeltaMaker.new(puffin)

    runner.stub_run_colour(puffin, :red)
    maker.run_test(red_time=[2014, 2, 15, 8, 54, 6])
    lights = puffin.lights
    assert_equal 1, lights.count
    assert_equal_light 1, :red, Time.mktime(*red_time), lights[0]

    runner.stub_run_colour(puffin, :amber)
    maker.run_test(amber_time=[2014, 2, 15, 8, 54, 34])
    lights = puffin.lights
    assert_equal 2, lights.count
    assert_equal_light 2, :amber, Time.mktime(*amber_time), lights[1]

    runner.stub_run_colour(puffin, :green)
    maker.run_test(green_time=[2014, 2, 15, 8, 55, 7])
    lights = puffin.lights
    assert_equal 3, lights.count
    assert_equal_light 3, :green, Time.mktime(*green_time), lights[2]

    n = 0
    lights.each do |light|
      n += 1
      assert_equal puffin, light.avatar
    end
    assert_equal 3, n

    assert_equal 3, lights.to_a.length

    a = lights.to_a
    assert_equal 'Array', a.class.name
    assert_equal 'Tag', a[0].class.name
  end

  #- - - - - - - - - - - - - - - - - - -

  private

  def assert_equal_light expected_number, expected_colour, expected_time, light
    assert_equal expected_colour, light.colour
    assert_equal expected_time  , light.time
    assert_equal expected_number, light.number
  end

end
