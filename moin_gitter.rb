#
# moving a selection of pages and plugins, from moinmoin, into a git repo
# useful when developing moinmoin plugins
#
# expecting a listing of the files to be moved, in a file using the following format:
# pages:
#   PageName
#   AnotherPageName
#
# plugin:
#    action/SomeActionPlugin.py
#    macro/SomeMacroPlugin.py
#    parser/SomeParserPlugin.py
#



require 'fileutils.rb'
files_to_git = "NOT_SET"
source_dir = 'NOT_SET'
target_dir = 'NOT_SET'

ARGV.each do |a|
  if a.start_with? "-source="
    source_dir = a["-source=".length..-1]
  elsif a.start_with? "-destination="
    target_dir = a["-destination=".length..-1]
  elsif a.start_with? "-files_to_git="
    files_to_git = a["-files_to_git=".length..-1]
  else
    print "Don\'t understand argument \"" + a + "\"\n"
  end
end

print "using source: \"" + source_dir + "\"\n"
print "using destination: \"" + target_dir + "\"\n"
print "using definition file: \"" + files_to_git + "\"\n"


unless File.file? files_to_git 
  abort "Can't find or read: \"" + files_to_git + "\". Quitting."
end

def handle_pages(source_dir, target_dir, directory)
  unless File.directory? target_dir
    FileUtils.mkdir_p target_dir
  end

  unless File.directory? target_dir + "/pages"
    FileUtils.mkdir_p target_dir + "/pages"
  end
  
  unless File.directory? (target_dir + "/pages/" + directory)
    FileUtils.mkdir_p (target_dir + "/pages/" + directory)
  end

  unless File.directory? (target_dir + "/pages/" + directory + "/revisions")
    FileUtils.mkdir_p (target_dir + "/pages/" + directory + "/revisions")
  end

  current = "00000001"
  File.open(source_dir + "/pages/" + directory + "/current", "r") do |infile|
    while(line = infile.gets)
      current = line.strip()
    end
  end
  
  FileUtils.copy(source_dir+"/pages/"+directory+"/revisions/"+current,
                 target_dir+"/pages/"+directory+"/revisions/00000001")

  File.open(target_dir+"/pages/"+directory+"/current","w+") {|f| 
    f.write("00000001")
  }
end

def handle_plugin(source_dir, target_dir, file)
  unless File.directory? target_dir
    FileUtils.mkdir_p target_dir
  end

  unless File.directory? target_dir + "/plugin"
    FileUtils.mkdir_p target_dir + "/plugin"
  end
  
  directory, filename = file.split('/')
  unless File.directory? (target_dir + "/plugin/" + directory)
    FileUtils.mkdir_p (target_dir + "/plugin/" + directory)
  end
  
  FileUtils.copy(source_dir+"/plugin/"+file,target_dir+"/plugin/"+file)
end

File.open(files_to_git, "r") do |infile|
    state = ""
    while (line = infile.gets)
      if line.strip() == ""
        next
      end
      if line.strip() == "pages:"
        state = "pages"
        next
      elsif line.strip() == "plugin:"
        state = "plugin"
        next
      end

      if state == "pages"
        handle_pages(source_dir, target_dir, line.strip())
      elsif state == "plugin"
        handle_plugin(source_dir, target_dir, line.strip())
      end
    end
end


