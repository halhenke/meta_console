# module MetaConsole::ConsoleMethods
module ConsoleMethods
  # ======================================================================
  # CONSOLE CUSTOMISATIONS
  # ======================================================================
  # Lets get stuff like try etc
   # - Try and find a way to stop this happening if called from the Rails Console?
   # - Prob not necessary - we are requiring after all....
  require 'active_support/all'

  # module ConsoleMethods

    # alias_method :dir, Module.conatants

    # Doing this because I dont think alias works between modules...
    def dir(inherited=false)
      Module.constants
    end

    # --------------------------------------------------
    # DASH
    # --------------------------------------------------
    def dash_ruby query
      %x(open $(echo "dash://ruby:#{query.to_s}"))
    end

    def dash_rails query, version=nil
      %x(open $(echo "dash://rails#{4 if version}:#{query}"))
    end

    # Lists all ruby files/scripts in a directory
    def read_scripts(dir, *num)
      if num.length > 0
        load_scripts(dir, num[0])
      else
        new_dir = File.expand_path dir
        # Dir.entries(dir).select{|fn| not fn.include?}
        # Dir.entries(dir).select{|fn| not fn =~ /(~$|)/}
        Dir.entries(new_dir).select{|fn| fn =~ /.rb$/}
      end
    end

    # Loads the nth file in the given directory based on its order as
    # returned by read_scripts
    def load_scripts(dir, num)
      new_dir = File.expand_path(dir) + "/"
      load(new_dir + read_scripts(new_dir)[num])
    end

    # Not sure where to put this really - should be in pry/irb/console
    # Can then call to get an indexed array of gem specs to be inspected
    # e.g.
    # : gem_array[0].description
    # : gem_array[0].dependencies
    def gem_array
      Gem.loaded_specs.values
    end
    # From the console - expanding all instance variables:
    # gem_array[0].instance_variables.map{ |v| gem_array[0].instance_variable_get v }

    # def c_map obj1
    #   obj1.map do |o|
    #     o.
    #   end
    # end
  # end

  #
end
