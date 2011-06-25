require 'GitDiffBuilder'
require 'GitDiffParser'

module GitDiff
  def git_diff_html(diff)
    max_digits = diff.length.to_s.length
    lines = diff.map {|n| diff_htmlify(n, max_digits) }.join("\n")
  end
  
  def diff_htmlify(n, max_digits)
      "<#{n[:type]}>" +
         '<ln>' + spaced_line_number(n[:number], max_digits) + '</ln>' +
         n[:line] + 
      "</#{n[:type]}>"
  end
  
  def spaced_line_number(n, max_digits)
      digit_count = n.to_s.length
      ' ' * (max_digits - digit_count) + n.to_s 
    end
  
  def git_diff_view(avatar, tag)
      
      cmd  = "cd #{avatar.folder};"
      cmd += "git show #{tag}:manifest.rb;"
      manifest = eval IO::popen(cmd).read
      visible_files = manifest[:visible_files]
      
      cmd  = "cd #{avatar.folder};"
      cmd += "git diff --ignore-space-at-eol --find-copies-harder #{tag-1} #{tag} sandbox;"   
      diff_lines = IO::popen(cmd).read
  
      view = {}
      builder = GitDiffBuilder.new()
      
      diffs = GitDiffParser.new(diff_lines).parse_all
      diffs.each do |sandbox_name,diff|
        
        md = %r|^(.)/sandbox/(.*)|.match(sandbox_name)
        if md[1] == 'b'
          name = md[2]
          # md[1] == 'a' indicates a deleted file
          # which of course is not in the manifest for this tag
          # I could handle this though, by retrieving it explicitly...
          file = visible_files[name]
          if file
            view[name] = builder.build(diff, line_split(file[:content]))
            visible_files.delete(name)
          else
            # I don't think this should never happen...
          end
        end
      end
      
      visible_files.each do |name,file|
        view[name] = sameify(file[:content])
      end
      
      view
  end
end
