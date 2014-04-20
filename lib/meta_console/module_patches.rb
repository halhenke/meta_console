# module MetaConsole::ModulePatches
module ModulePatches
  # ======================================================================
  # Monkey-Patching Module with some useful reflective methods
  # Remember - there is a difference between
  # - Module#constants (modules and classes defined in the module),
  #   Module#included_modules (modules we included)
  #   and Module#ancestors (modules we included and all parent classes)
  # ======================================================================
  class ::Module
    # ALIASES
    alias_method :c, :constants
    alias_method :aa, :attr_accessor
    # alias_method :cv, :class_variables
    # alias_method :im, :instance_methods

    # SHORTER METHOD NAMES
    #  - WITH OPTIONAL MATCH DATA TO GREP AGAINST
    # Argument should be in the form /arg/
    # rather than "arg" and all will be work
    def im(match=false)
      if match
        self.instance_methods.grep(match)
      else
        self.instance_methods
      end
    end
    def cv(match=false)
      if match
        self.class_variables.grep(match)
      else
        self.class_variables
      end
    end
    def imf(match=false)
      if match
        self.instance_methods(false).grep(match)
      else
        self.instance_methods false
      end
    end
    def cvf(match=false)
      if match
        self.class_variables  (false).grep(match)
      else
        self.class_variables false
      end
    end

    # method to take a module and list all included modules/ancestors that are actually classes
    # - the idea would be to take for example a module such as Gem and find the namespace from which to call the actually useful commands
    def classes
      # Not going to work - ancestors returns only modules
      # self.ancestors.select{ |m| m.class == Class}
      self.constants.select do |c|
        self.sub_mod(c.to_s).class == Class
      end.map do |c|
          self.sub_mod(c.to_s)
      end
    end
    # Refactoring out this method to get an actual Module object if given a string
    #  thats the name of an included module...
    def sub_mod(mod)
      eval("#{self.name}::" + mod)
    end
    # Those classes that contain/define new class methods
    # - Seems to work OK
    def m_classes
      self.constants.select do |c|
        mod = self.sub_mod(c.to_s)
        mod.class == Class && (mod.methods(false).count > 0)
      end.map do |c|
        self.sub_mod(c.to_s)
      end
    end
    # Those classes that contain/define new instance methods
    # - this doesnt really seem to work properly right now - outputs nothing
    def i_m_classes
      self.constants.select do |c|
        mod = self.sub_mod(c.to_s)
        mod.class == Class && (mod.instance_methods(false).count > 0)
      end.map do |c|
        self.sub_mod(c.to_s)
      end
    end
    # A method to return basic info about the methods in a modlue
    # - Basically works OK i guess - could be prettier
    #   error doesnt work for some stuff e.g.
    #   Bundler.classes_info
    # NameError: uninitialized constant Bundler::Specification
    # REASON - autoload is declaring a module but that module
    # isnt actually found in the named file
    # module Bundler
    #   autoload :Specification,         'bundler/shared_helpers'
    # This version prints out strings
    def classes_info
      self.constants.select do |c|
        mod = self.sub_mod(c.to_s)
        mod.class == Class && (mod.methods(false).count > 0)
      end.each do |c|
          mod = self.sub_mod(c.to_s)
          ap "#{c.to_s} class methods: #{mod.methods(false).count}"
          ap "#{c.to_s} instance methods: #{mod.instance_methods(false).count}"
      end
      "...Dont want to print self.constants.select etc..."
    end
    # Version that prints out a hash so that AwesomePrint colours differently for readability
    # def classes_info
    #   out = {}
    #   self.constants.select{ |c|
    #     mod = self.sub_mod(c.to_s)
    #     mod.class == Class && (mod.methods(false).count > 0)
    #   }.each { |c|
    #       mod = self.sub_mod(c.to_s)
    #       out["#{c.to_s} class methods: "] = "#{mod.methods(false).count}"
    #       out["#{c.to_s} instance methods: "] = "#{mod.instance_methods(false).count}"
    #   }
    #   ap out
    #   "...Dont want to print self.constants.select etc..."
    # end

    # Returns the class where a particular method is found if given a method name
    def class_for_meth(meth)
    end
    # Calls a particular method that may be defined/bound to a module further
    # down the Module inheritance tree
    def call_meth(meth)
    end
  end

  #    # Relies on Method doc Monkey Patch below - should we be patching a docstring straight onto every object? No - we want docstrings on classes, Methods and maybe modules
  #    def doc_string method_name
  #      self.method(method_name).doc
  #    end
  # end

  #  # More Monkey Patching - this time adding a doc string on to the method object
  #  # Got this from
  #  # https://gist.github.com/chendo/2146319
  #  # - Not sure how much this works.....
  #  class Method
  #    def doc= doc_string
  #      @doc = doc_string
  #    end
  #    def doc
  #      @doc ||= begin
  #                 path, line_number = source_location
  #                 return nil unless path && File.exists?(path)
  #                 file = File.read(path)
  #                 if file =~ Regexp.new(%Q{\\A(?:.*?\n){#{line_number}}\s*?"""([\\s\\S]+?)"""})
  #                   $1.gsub(/\n\s+/, "\n").strip
  #                 else
  #                   nil
  #                 end
  #               end
  #    end
  #  end

  #
  # ======================================================================
end
