
module LanguagesRename # mix-in

  module_function

  def renamed(name)
    # maps from old display_name to new display_name
    # see comment at bottom of file.
    renames = {
      # from way back when test name was _not_ part of language name
      ['BCPL']         => ['BCPL',         'all_tests_passed'],
      ['C']            => ['C (gcc)',      'assert'],
      ['C++']          => ['C++ (g++)',    'assert'],
      ['C#']           => ['C#',           'NUnit'],
      ['Clojure']      => ['Clojure',      '.test'],
      ['CoffeeScript'] => ['CoffeeScript', 'jasmine'],
      ['Erlang']       => ['Erlang',       'eunit'],
      ['Go']           => ['Go',           'testing'],
      ['Haskell']      => ['Haskell',      'hunit'],
      ['Java']         => ['Java',         'JUnit'],
      ['Javascript']   => ['Javascript',   'assert'],
      ['Perl']         => ['Perl',         'Test::Simple'],
      ['PHP']          => ['PHP',          'PHPUnit'],
      ['Python']       => ['Python',       'unittest'],
      ['Ruby']         => ['Ruby',         'Test::Unit'],
      ['Scala']        => ['Scala',        'scalatest'],
      # renamed
      ['C++',        'catch']            => ['C++ (g++)' , 'Catch'],
      ['Java',       'ApprovalTests']    => ['Java',       'Approval'],  # offline
      ['Java',       'JUnit','Mockito']  => ['Java',       'Mockito'],
      ['Javascript', 'mocha_chai_sinon'] => ['Javascript', 'Mocha+chai+sinon'],
      ['Perl',       'TestSimple']       => ['Perl',       'Test::Simple'],
      ['Ruby',       'Rspec']            => ['Ruby',       'RSpec'],     # capital S
      ['Ruby',       'TestUnit']         => ['Ruby',       'Test::Unit'],
      ['Python',     'pytest']           => ['Python',     'py.test'],   # dot
      # - in the wrong place
      ['Java', '1.8_Approval']     => ['Java', 'Approval'],  # offline
      ['Java', '1.8_Cucumber']     => ['Java', 'Cucumber'],
      ['Java', '1.8_JMock']        => ['Java', 'JMock'],
      ['Java', '1.8_JUnit']        => ['Java', 'JUnit'],
      ['Java', '1.8_Mockito']      => ['Java', 'Mockito'],
      ['Java', '1.8_Powermockito'] => ['Java', 'PowerMockito'],
      # replaced
      ['R', 'stopifnot'] => ['R', 'RUnit'],
      # renamed to distinguish from [C (clang)]
      ['C', 'assert']   => ['C (gcc)', 'assert'],
      ['C', 'Unity']    => ['C (gcc)', 'Unity'],
      ['C', 'CppUTest'] => ['C (gcc)', 'CppUTest'],
      # renamed to distinguish from [C++ (clang++)]
      ['C++', 'assert']     => ['C++ (g++)', 'assert'],
      ['C++', 'Boost.Test'] => ['C++ (g++)', 'Boost.Test'],
      ['C++', 'Catch']      => ['C++ (g++)', 'Catch'],
      ['C++', 'CppUTest']   => ['C++ (g++)', 'CppUTest'],
      ['C++', 'GoogleTest'] => ['C++ (g++)', 'GoogleTest'],
      ['C++', 'Igloo']      => ['C++ (g++)', 'Igloo'],
      ['C++', 'GoogleMock'] => ['C++ (g++)', 'GoogleMock'],

    }
    (renames[name.split('-')] || []).join(', ')
  end

end

# - - - - - - - - - - - - - - - - - - - - - - - -
# Upgrading? Multiple language versions?
# - - - - - - - - - - - - - - - - - - - - - - - -
# It's common to want to add a new test-framework to
# an existing language and, when doing this, to take
# advantage of upgrading the language to a newer version.
#
# For example
#    Ruby1.9.3/Approval
#    Ruby1.9.3/Cucumber
#    Ruby1.9.3/Rspec
#    Ruby1.9.3/TestUnit
# existed when I wanted to add MiniTest as a new Ruby test-framework.
# By then the latest Ruby version was 2.1.3
#    Ruby2.1.3/MiniTest
#
# I didn't want to have to upgrade the existing Ruby1.9.3 test-frameworks
# to Ruby2.1.3. But... on the create page I wanted all the different
# Ruby test-frameworks (from two different versions of Ruby) to appear
# under the *same* language name in the language? column.
# This is why a language/test's  manifest.json file has a display_name entry.
# It is the display_name that governs the language/test's names as they appear
# on the create page. Not the folder names. Not the docker image_name.
#
# Further, if you upgrade a language/test to a newer version
# and delete the old version of the docker container from your server,
# you still want to be able to fork from a kata done in the old version
# (particularly for well known katas's such as the refactoring ones).
# And when you do such a fork you want the new kata to use the new version.
# So what is stored in the kata's manifest is *not* the docker container's
# image_name but the display_name.
#
# rename() is a bit fiddly because historically the language-&-test
# were *not* separated into distinct nested folders.
# - - - - - - - - - - - - - - - - - - - - - - - -
