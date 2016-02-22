#!/bin/bash ../test_wrapper.sh

require_relative './app_lib_test_base'

class GitDiffViewTests < AppLibTestBase

  include GitDiff

  test '836292',
  'simple example going from red to green' do
    diffs =
    {
      'hiker.rb' =>
      [
        { :line => '',           :type => :same,    :number => 1 },
        { :line => 'def answer', :type => :same,    :number => 2 },
        { :type => :section, :index => 0 },
        { :line => '  6 * 9',       :type => :deleted, :number => 3 },
        { :line => '  6 * 7',       :type => :added,   :number => 3 },
        { :line => 'end',        :type => :same,    :number => 4 },
      ]
    }
    view = git_diff_view(diffs)

    expected_view =
    [
      {
        :id => "id_0",
        :filename => "hiker.rb",
        :section_count => 1,
        :deleted_line_count => 1,
        :added_line_count => 1,
        :content =>
          "<same>&thinsp;</same>" +
          "<same>def answer</same>" +
          "<span id='id_0_section_0'></span>" +
          "<deleted>  6 * 9</deleted>" +
          "<added>  6 * 7</added>" +
          "<same>end</same>",
        :line_numbers =>
          "<same><ln>1</ln></same>" +
          "<same><ln>2</ln></same>" +
          "<deleted><ln>3</ln></deleted>" +
          "<added><ln>3</ln></added>" +
          "<same><ln>4</ln></same>"
      }
    ]
    assert_equal expected_view, view
  end

  # - - - - - - - - - - - - - - - - - -

  private

  def one_line(content)
    [ { :line => content, :type => :same, :number => 1 } ]
  end

  def one_line_expected(n, filename, content)
    {
      :id => 'id_' + n.to_s,
      :filename => filename,
      :section_count => 0,
      :deleted_line_count => 0,
      :added_line_count => 0,
      :content => '<same>' + content + '</same>',
      :line_numbers => '<same><ln>1</ln></same>'
    }
  end

end
