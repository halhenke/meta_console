# puts "MetaConsole Gem is being read..."

Dir[File.dirname(__FILE__) + "/meta_console/*.rb"].each { |file|
  # puts "About to require " + file
  require file }

module MetaConsole
  # Your code goes here...

  # include MetaConsole::ConsoleMethods
  # include MetaConsole::RailsMethods
  # include MetaConsole::ObjectPatches
  # include MetaConsole::ModulePatches
  include ConsoleMethods
  include RailsMethods
  include ObjectPatches
  include ModulePatches
end
