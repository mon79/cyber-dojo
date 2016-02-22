
module TestTmpRootHelpers # mix-in

  module_function

  def tmp_key
    'CYBER_DOJO_TMP_ROOT'
  end

  def tmp_root
    root = ENV[tmp_key]
    ram_disk = '/mnt/ram-disk'
    root ||= ram_disk + '/cyber-dojo'     if File.directory?(ram_disk)
    not_ram_disk = '/tmp'
    root ||= not_ram_disk + '/cyber-dojo' if File.directory?(not_ram_disk)
    root.end_with?('/') ? root : (root + '/')
  end

  def setup_tmp_root
    # the Teardown-Before-Setup pattern gives good diagnostic info if
    # a test fails but these backtick command mean the tests cannot be
    # run in parallel...
    `rm -rf #{tmp_root}`
    `mkdir -p #{tmp_root}`
    fail RuntimeError.new("#{tmp_root} does not exist") unless File.directory?(tmp_root)
  end

end
