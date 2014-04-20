# module MetaConsole::ObjectPatches
module ObjectPatches
  # ======================================================================
  # Monkey-Patching Object with some metamethods
  class ::Object
    # ALIASES
    # alias_method :iv, :instance_variables

   # Report changed message names
    def report_changed_meths(rails=false)
      report = []
      report.push "------------------------"
      report.push "IN OBJECT CLASS:"
      report.push "o.iv === o.instance_variables"
      # report.push "o.own_methods === o.methods(false)"
      report.push "o.ms === o.methods(false)"
      report.push "------------------------"
      report.push "IN MODULE CLASS:"
      report.push "o.im === o.instance methods"
      report.push "o.imf === o.instance methods(false)"
      report.push "o.cv === o.class_variables"
      report.push "o.cvf === o.class_variables(false)"
      report.push " - Other stuff that doesnt maybe work that great..."
      report.push "m.classes === ..."
      report.push "m.classes_info === ..."
      report.push "m.sub_mod === ..."
      report.push "m.m_classes === ..."
      report.push "m.i_m_classes === ..."
      report.push " - Not even implemented..."
      report.push "m.class_for_meth(m) === ..."
      report.push "m.call_meth(m) === ..."
      report.push "------------------------"
      report.push "CONSOLE METHODS..."
      report.push "c.read_scripts === ...."
      report.push "c.load_scripts === ...."
      report.push "c.gem_array === ...."
      if Rails
        report.push "------------------------"
        report.push "RAILS ONLY: ALIASED METHODS..."
        report.push "r.anames === :attribute_names"
        report.push "r.roaa === :reflect_on_all_associations"
        report.push "------------------------"
        report.push "RAILS ONLY: CONSOLE METHODS..."
        report.push "rc.rails_models === ...."
        report.push "------------------------"
        report.push "RAILS ONLY: CLASS METHODS ON ACTIVERECORD::BASE..."
        report.push "r.ahash === ...."
        report.push "r.roaab === pretty version of :roaa/:reflect_on_all_associations - brief arguments also"
        report.push "r.agrep(match) === ...."
        report.push "r.last_range(first, last) === ...."
        report.push "r.first_range(last, first) === ...."
        report.push "r.all_map(atts) === ...."
        report.push "------------------------"
        report.push "RAILS ONLY: INSTANCE METHODS ON ACTIVERECORD::BASE..."
        report.push "r.anames === ...."
        report.push "r.agrep(match) === ...."
        report.push "r.alt_grep(match) === ...."
      end
      report.push "------------------------"
      if defined? ap
        report.each{ |l| ap l}
      else
        report.each{ |l| puts l}
      end
      nil
    end

    # META OBJECT RELATED METHODS
    # The hidden singleton lurks behind everyone
     def metaclass
       class << self
         self
       end
     end

     def meta_eval &blk
       metaclass.instance_eval &blk
     end

     # Adds methods to a metaclass
     def meta_def name, &blk
       meta_eval { define_method name, &blk }
     end

     # Defines an instance method within a class
     def class_def name, &blk
       class_eval { define_method name, &blk }
     end

     # ## EASY METHOD INTROSPECTION
     # I really have to clean these methods up... Better names etc

     # Return a sorted list of methods minus those which are inherited from Object
     # Actually this is reproduable by just calling self.method(false)

     # SHORTER METHOD NAMES
    def iv(match=false)
      if match
        instance_variables.grep(match)
      else
        instance_variables
      end
    end
    # def own_methods(match=false)
    def ms(match=false)
       # (self.methods - Object.instance_methods).sort
       if match
         self.methods(false).grep(match)
       else
         self.methods false
       end
    end

     # An optionally searchable list of instance methods
     def g_meth(match, all=true)
      # debugger
      if self.class == Class
        self.instance_methods(all).grep match
      else
        self.methods(all).grep match
      end
     end

     # Relies on Method doc Monkey Patch below - should we be patching a docstring straight onto every object? No - we want docstrings on classes, Methods and maybe modules
     def doc_string method_name
       self.method(method_name).doc
     end

     # Trying to add a cool try stub_chain thing - hope this works even if ActiveSupport might not be required yet
     def try_chain(*args)
       args.size > 1 ? eval("self.try(args[0]).try_chain(#{args[1..-1].inspect[1..-2]})") : self.try(args[0])
     end
  end
  # ======================================================================
end
