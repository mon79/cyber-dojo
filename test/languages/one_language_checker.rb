
require_relative '../all'
require_relative '../test_domain_helpers'
require_relative '../test_external_helpers'

class OneLanguageChecker

  include TestDomainHelpers
  include TestExternalHelpers

  def initialize(verbose)
    @verbose = verbose
  end

  def check(name, test, verbose = @verbose)
    language_name = [name, test].join('-')
    @language = Language.new(languages, name, test)
    fail "Language.new(#{name},#{test}).nil?" if @language.nil?
    if true #@language.runnable?
      vputs "  #{@language.name} " + ('.' * (35 - @language.name.to_s.length))
      t1 = Time.now
      rag = red_amber_green
      t2 = Time.now
      took = ((t2 - t1) / 3).round(2)
      vputs " (~ #{took} seconds each)\n"
      rag
    else
      vputs " #{@language.name} is not runnable"
    end
  end

private

  include TimeNow

  def red_amber_green
    # creates a new *dojo* for each red/amber/green
    [:red, :amber, :green].map { |colour|
      begin
        language_test(colour)
      rescue Exception => e
        e.message
      end
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def language_test(colour)
    exercise = exercises['Fizz_Buzz']
    kata = katas.create_kata(@language, exercise)
    avatar = kata.start_avatar

    pattern = pattern_6times9

    from = pattern[:red]
    filename = filename_6times9(from)
    to = pattern[colour]

    # Cucumber tests special case handling
    if @language.name == 'Java-Cucumber' && colour == :amber
      filename = 'Hiker.java'
      from = '}'
      to = '}typo'
    end

    visible_files = @language.visible_files
    test_code = visible_files[filename]

    visible_files[filename] = test_code.sub(from, to)

    vputs [
      "<test_code id='#{kata.id}' avatar='#{avatar.name}' expected_colour='#{colour}'>",
      visible_files[filename],
      "</test_code>"
    ].join("\n")

    delta = {
      :changed => [filename],
      :unchanged => visible_files.keys - [filename],
      :deleted => [],
      :new => []
    }

    now = time_now
    max_seconds = 60
    traffic_lights,_,_ = avatar.test(delta, visible_files, now, max_seconds)

    vputs [
      "<output>",
      visible_files['output'],
      "</output>"
    ].join("\n")

    rag = traffic_lights.last['colour']

    vputs [
      "<test_code actual_colour='#{rag}'>",
      "</test_code>"
    ].join("\n")

    print '.'
    rag
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def pattern_6times9
    case (@language.name)
      when 'Clojure-.test'
        then make_pattern('* 6 9')
      when 'Java-Cucumber',
           'Ruby-Cucumber'
        then make_pattern('6 times 9')
      when 'Java-Mockito',
           'Java-PowerMockito'
        then make_pattern('thenReturn(9)')
      when 'Asm-assert'
        then make_pattern('mov ebx, 9')
      when 'VHDL-assert'
        then make_pattern('00110110')
      else
        make_pattern('6 * 9')
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def make_pattern(base)
    if base == '00110110' # special case for VHDL
      { :red   => base,
        :amber => base.sub('00110110', '00110110typo'),
        :green => base.sub('00110110', '00101010')
      }
    else
      { :red   => base,
        :amber => base.sub('9', '9typo'),
        :green => base.sub('9', '7')
      }
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def filename_6times9(pattern)
    filenames = @language.visible_filenames.select { |visible_filename|
      IO.read(@language.path + visible_filename).include? pattern
    }
    if filenames == []
      message = " no '#{pattern}' file found"
      vputs alert + message
      raise message
    end
    if filenames.length > 1
      message = " multiple '#{pattern}' files " + filenames.inspect
      vputs alert + message
      raise message
    end
    vputs "."
    filenames[0]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def alert
    "\n>>>#{@language.name}<<\n"
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def vputs(message)
    puts message if @verbose
  end

end
