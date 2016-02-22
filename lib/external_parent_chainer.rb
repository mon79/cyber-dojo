
module ExternalParentChainer # mix-in

  def method_missing(command, *args)
    current = self
    loop { current = current.parent }
  rescue NoMethodError
    raise "not-expecting-arguments #{args}" if args != []
    current.send(command, *args)
  end

end

# Provides transparent access to the external objects held in the root dojo object:
#
#  one_self - currently used on globe showing latitude+logtitude red dots.
#  starter  - ensures starting an animal in a cyber-dojo has appropriate locking.
#  runner   - performs the actual test run, usually using docker in some way.
#  shell    - executes shell commands, eg mkdir,ls,git
#  disk     - access to the file-system, directories, file read/write
#  log      - memory based logging (useful for testing)
#  git      - all required git commands. Forwards to shell.
#
# The root dojo object also holds objects representing the main cyber-dojo folders:
#
# languages - as per setup page. read-only
# exercises - as per setup page. read-only
# caches    - where languages,exercises,runners caches are held. read-only
# katas     - where cyber-dojo's are created. read-write
#
# Allows the lib/ classes representing external objects to easily access
# each other by chaining back to the root dojo object. For example:
#
#     HostGit   -> shell -> dojo.shell -> HostShell
#     HostShell -> log   -> dojo.log   -> HostLog
#
# Works by assuming the object which included this module has a parent
# property and repeatedly chains back parent to parent to parent
# till it gets to an object without a parent property which it assumes
# is the root dojo object, which it that delegates to.
