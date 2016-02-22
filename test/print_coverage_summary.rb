#!/usr/bin/env ruby

def modules
   ARGV
end

def wrapper_test_log
  # duplicated in test/test_wrapper.sh
  'coverage/WRAPPER.log.tmp'
end

#- - - - - - - - - - - - - - - - - - - - -

def f2(s)
  result = ("%.2f" % s).to_s
  result += '0' if result.end_with?('.0')
  result
end

def padded(width,it)
  " " * (width - it.to_s.length)
end

def print_left(width,it)
  print it.to_s + padded(width,it)
end

def print_right(width,it)
  print padded(width,it) + it.to_s
end

def indent
  16
end

def line_width
  columns.map{|_,values| values[0]}.reduce(:+) + indent
end

def print_line
  puts ' -' * ((line_width+1)/2)
end

#- - - - - - - - - - - - - - - - - - - - -

def column_names
  [
    :test_count,
    :assertion_count,
    :failure_count,
    :error_count,
    #:skip_count,
    :time,
    :tests_per_sec,
    :assertions_per_sec,
    :coverage
  ]
end

#- - - - - - - - - - - - - - - - - - - - -

def columns
  names = column_names
  n = -1
  {
    names[n += 1] => [  5, 't',      'number of tests'       ],
    names[n += 1] => [  7, 'a',      'number of assertions'  ],
    names[n += 1] => [  3, 'f',      'number of failures'    ],
    names[n += 1] => [  3, 'e',      'number of errors'      ],
    #names[n += 1] => [  3, 's',      'number of skips'       ],
    names[n += 1] => [  7, 'secs',   'time in seconds'       ],
    names[n += 1] => [  7, 't/sec',  'tests per second'      ],
    names[n += 1] => [  7, 'a/sec',  'assertions per second' ],
    names[n += 1] => [  9, 'cov',    'coverage %'            ],
  }
end

#- - - - - - - - - - - - - - - - - - - - -

def gather_stats
  stats = {}
  number = '([\.|\d]+)'
  modules.each do |module_name|

    log = `cat #{module_name}/#{wrapper_test_log}`
    `rm #{module_name}/#{wrapper_test_log}`
    h = stats[module_name] = { }

    finished_pattern = "Finished in #{number}s, #{number} runs/s, #{number} assertions/s"
    m = log.match(Regexp.new(finished_pattern))
    h[:time]               = f2(m[1])
    h[:tests_per_sec]      = m[2].to_i
    h[:assertions_per_sec] = m[3].to_i

    summary_pattern = %w(runs assertions failures errors skips).map{ |s| "#{number} #{s}" }.join(', ')
    m = log.match(Regexp.new(summary_pattern))
    h[:test_count]      = m[1].to_i
    h[:assertion_count] = m[2].to_i
    h[:failure_count]   = m[3].to_i
    h[:error_count]     = m[4].to_i
    #h[:skip_count]      = m[5].to_i

    coverage_pattern = "Coverage of ([^\=]*) = #{number}%"
    m = log.match(Regexp.new(coverage_pattern))
    h[:coverage] = f2(m[2])
  end
  stats
end

#- - - - - - - - - - - - - - - - - - - - -

def print_column_keys
  column_names.each do |name|
    puts columns[name][1] + ' == ' + columns[name][2]
  end
end

#- - - - - - - - - - - - - - - - - - - - -

def print_heading
  print_left(indent, '')
  column_names.each { |name| print_right(columns[name][0], columns[name][1]) }
  print "\n"
end

#- - - - - - - - - - - - - - - - - - - - -

def print_stats(stats)
  modules.each do |module_name|
    h = stats[module_name]
    print_left(indent, module_name)
    column_names.each { |name| print_right(columns[name][0], stats[module_name][name]) }
    print "\n"
  end
end

#- - - - - - - - - - - - - - - - - - - - -

def print_totals(stats)
  pr = lambda { |key,value| print_right(columns[key][0], value) }
  stat = lambda { |key| stats.map{|_,h| h[key].to_i}.reduce(:+) }
  print_left(indent, 'total')
  pr.call(name=:test_count, c = stat.call(name))
  pr.call(name=:assertion_count, a = stat.call(name))
  pr.call(name=:failure_count, stat.call(name))
  pr.call(name=:error_count, stat.call(name))
  #pr.call(name=:skip_count, stat.call(name))
  pr.call(name=:time, t = f2(stats.map { |_,h| h[name].to_f }.reduce(:+)))
  pr.call(:tests_per_sec,        (c / t.to_f).to_i)
  pr.call(:assertions_per_sec,   (a / t.to_f).to_i)
end

#- - - - - - - - - - - - - - - - - - - - -

stats = gather_stats
print_column_keys
print "\n"
print_heading
print_line
print_stats(stats)
print_line
print_totals(stats)
print "\n"
print "\n"
