# module MetaConsole::RailsMethods
module RailsMethods
  # ======================================================================
  # Rails
  # ======================================================================
  # Things to do in a Rails Env but that wont work in other situations...
  # ======================================================================

  if defined? Rails
    # I hate typing this long ass shit
    require 'active_record'


    module ConsoleMethods
      # List all ActiveRecord models defined in the current project - Doesnt list subclasses yet
      # def rails_models
        # Module.constants.select do |constant_name|
        #   constant = eval constant_name
        #   if not constant.nil? and constant.is_a? Class and constant.superclass == ActiveRecord::Base
        #     constant
        #   end
        # end

      # List all ActiveRecord models defined in the current project - Doesnt work great yet
      def rails_models
        ActiveRecord::Base.send(:subclasses).each do |model|
          puts model.name
        end
      end
    end



    # ======================================================================
    # == ACTIVE RECORD CLASS METHODS....
    # ======================================================================
    class << ActiveRecord::Base
      # --------------------------------------------------
      # Aliases
      # --------------------------------------------------
      alias_method :anames, :attribute_names
      alias_method :roaa, :reflect_on_all_associations
      # Also get this working for instances of Active Record - possibly printing out both names and values...
      alias_method :f, :find
      # --------------------------------------------------


      module HalStuff
        def self.association_converter
          {
            bt:     :belongs_to,
            ho:     :has_one,
            hm:     :has_many,
            habtm:  :has_and_belongs_to_many
          }
        end
      end

      # Use pluck, and a bunch of other stuff to be able to just ask for something like
      # User :all, name, age
      # [User.pluck :name, User.pluck :age]
      # User 56, name, age
      # [User.find(56).name, User.find(56).age]
      # Maybe also an optional first/last pos arg like l4 => last 4, f4 => first 4
      # SOMEHOW - also get it working with an ActiveRelation & possibly also an Array
      # - basically would have to call map on the relation i think
      def g *opts
        case opts.count
        when 0
          return self
        # when 1
        #   first = opts.first
        #   return self.find()
        else
          first = opts.first
          rest  = opts.slice(1..-1)
          case
            when first == :all
              has_args?(opts) ? self.pluck4(rest) : self.all
            when (first.is_a? Symbol) && m = (/^f(\d*)/).match(first)
              has_args?(opts) ? self.pluck4(rest).first(m[1].to_i) : self.first(m[1].to_i)
            when (first.is_a? Symbol) && m = (/^l(\d*)/).match(first)
              has_args?(opts) ? self.pluck4(rest).last(m[1].to_i) : self.last(m[1].to_i)
            when first.integer?
              # THIS WILL ONLY WORK FOR ATTRIBUTES - NOT METHODS
              has_args?(opts) ? rest.map { |a| self.find(first)[a] } : self.find(first)
          end
        end
      end

      # pluck is way coooler in Rails 4
      # make this so that its only defined if Rails < 4 - and somehow works with above...
      def pluck4 feathers
        if Rails.version =~ /^3/
          self.all.map{ |ar|
            feathers.map { |f|
              # THIS WILL ONLY WORK FOR ATTRIBUTES - NOT METHODS
              ar[f]
            }
            #.join(", ")  RETURN AS STRING? OPTIONAL
          }
        else
          self.pluck feathers
        end
      end

      # reflect_on_all_associations brief form
      def roaab(opt = nil)
        opt ||= HalStuff.association_converter.keys
        opt.each do |a_type|
          assoc = HalStuff.association_converter[a_type]
          next unless assoc
          ap "#{assoc} Associations:"
          # ap roaa(assoc).map{ |a| a.name.to_s.classify }
          roaa(assoc).each do |a|
            puts "\t #{a.name.to_s.classify }"
          end
        end
        nil
      end

      def ahash
        Hash[columns.map { |c| [c.name, c.type] }]
      end

      def agrep match
        # attribute_names.grep match
        Hash[columns.select{ |c| c.name.match match }.map { |c| [c.name, c.type] }]
      end

      # Return a range of records from the end of the table
      # e.g. to return the second and third last records
      # MyModel.last_range(3, 1)
      def last_range(first, last)
        self.last(first) - self.last(last)
      end

      # Return a range of records from the beginning of the table
      # e.g. to return the second and third records
      # MyModel.first_range(1, 3)
      def first_range(last, first)
        self.first(first) - self.first(last)
      end

      # Now do a method that you can pass a list of ranges and will call
      # one of the previous methods repeatedly....

      # Methods to show previously defined scopes for an active record

      # Should take a list of symbols and then return a string for
      # each record where the value for each symbol is returned
      def all_map(atts)
        self.all.map do |m|
          atts.reduce("") do |s,a|


            s + o.call(a).to_s + " " + a.to_s
          end
        end
      end

    end

    # ======================================================================
    # == ACTIVE RECORD INSTANCE METHODS....
    # ======================================================================
    class ActiveRecord::Base
      # resulting methods dont seem to work..
      # ALSO THEY SEEM TO BREAK ActiveRecord::Base::save
      # ArgumentError: wrong number of arguments (0 for 1..2)
      # from /Users/Hal/.rvm/gems/ruby-2.0.0-p353@rails3/gems/activerecord-3.2.16/lib/active_record/persistence.rb:212:in `update_attributes'
      # if Rails.version.gsub(/\..*/,'').to_i < 4
      #   alias_method :update, :update_attributes
      #   alias_method :update!, :update_attributes!
      # end

      # Just returning attributes gives a hash that is automatically nicely formatted by AwesomePrint...
      def a_names(match=false)
        if match
          self.attributes.select{ |k,v| k.match match}
        else
          self.attributes
        end
        # This just returns a crappy list of strings
        # self.class.attribute_names
      end
      # Should make match an optional argument and return either just self.attributes or the below
      def agrep match
        self.attributes.select{|k,v| k.match match}
      end
      # Actually this ended up being a sucky alternative....
      # To make worthwhile would have to put back into a hash form - maybe for class methods where we dont have attributes...
      def alt_grep match
        self.class.inspect.split(",").map(&:strip).select{|s| s.match match}
      end
    end
  end
end
