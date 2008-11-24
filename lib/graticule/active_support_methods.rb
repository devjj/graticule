# This module contains the methods used in ActiveSupport.  Allows us to use extlib (for Merb) without having to load in the entirety of ActiveSupport.

module Graticule
  module ObjectExtensions
    # A Ruby-ized realization of the K combinator, courtesy of Mikael Brockman.
    #
    #   def foo
    #     returning values = [] do
    #       values << 'bar'
    #       values << 'baz'
    #     end
    #   end
    #
    #   foo # => ['bar', 'baz']
    #
    #   def foo
    #     returning [] do |values|
    #       values << 'bar'
    #       values << 'baz'
    #     end
    #   end
    #
    #   foo # => ['bar', 'baz']
    #
    def returning(value)
      yield(value)
      value
    end
  end
  
  module StringExtensions
    # By default, +camelize+ converts strings to UpperCamelCase. If the argument to camelize
    # is set to <tt>:lower</tt> then camelize produces lowerCamelCase.
    #
    # +camelize+ will also convert '/' to '::' which is useful for converting paths to namespaces.
    #
    #   "active_record".camelize                # => "ActiveRecord"
    #   "active_record".camelize(:lower)        # => "activeRecord"
    #   "active_record/errors".camelize         # => "ActiveRecord::Errors"
    #   "active_record/errors".camelize(:lower) # => "activeRecord::Errors"
    def camelize(first_letter = :upper)
      case first_letter
        when :upper then _camelize(self, true)
        when :lower then _camelize(self, false)
      end
    end
    alias_method :camelcase, :camelize

    # By default, +camelize+ converts strings to UpperCamelCase. If the argument to +camelize+
    # is set to <tt>:lower</tt> then +camelize+ produces lowerCamelCase.
    #
    # +camelize+ will also convert '/' to '::' which is useful for converting paths to namespaces.
    #
    # Examples:
    #   "active_record".camelize                # => "ActiveRecord"
    #   "active_record".camelize(:lower)        # => "activeRecord"
    #   "active_record/errors".camelize         # => "ActiveRecord::Errors"
    #   "active_record/errors".camelize(:lower) # => "activeRecord::Errors"
    def _camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
      if first_letter_in_uppercase
        lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      else
        lower_case_and_underscored_word.first + camelize(lower_case_and_underscored_word)[1..-1]
      end
    end

    def titleize
      _titleize(self)
    end
    alias_method :titlecase, :titleize

    # Capitalizes all the words and replaces some characters in the string to create
    # a nicer looking title. +titleize+ is meant for creating pretty output. It is not
    # used in the Rails internals.
    #
    # +titleize+ is also aliased as as +titlecase+.
    #
    # Examples:
    #   "man from the boondocks".titleize # => "Man From The Boondocks"
    #   "x-men: the last stand".titleize  # => "X Men: The Last Stand"
    def _titleize(word)
      _humanize(_underscore(word)).gsub(/\b('?[a-z])/) { $1.capitalize }
    end
    
    # The reverse of +camelize+. Makes an underscored, lowercase form from the expression in the string.
    # 
    # +underscore+ will also change '::' to '/' to convert namespaces to paths.
    #
    #   "ActiveRecord".underscore         # => "active_record"
    #   "ActiveRecord::Errors".underscore # => active_record/errors
    def underscore
      _underscore(self)
    end

    # The reverse of +camelize+. Makes an underscored, lowercase form from the expression in the string.
    #
    # Changes '::' to '/' to convert namespaces to paths.
    #
    # Examples:
    #   "ActiveRecord".underscore         # => "active_record"
    #   "ActiveRecord::Errors".underscore # => active_record/errors
    def _underscore(camel_cased_word)
      camel_cased_word.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end
    
    # Capitalizes the first word, turns underscores into spaces, and strips '_id'.
    # Like +titleize+, this is meant for creating pretty output.
    #
    #   "employee_salary" # => "Employee salary" 
    #   "author_id"       # => "Author"
    def humanize
      _humanize(self)
    end
    
    # Capitalizes the first word and turns underscores into spaces and strips a
    # trailing "_id", if any. Like +titleize+, this is meant for creating pretty output.
    #
    # Examples:
    #   "employee_salary" # => "Employee salary"
    #   "author_id"       # => "Author"
    def _humanize(lower_case_and_underscored_word)
      lower_case_and_underscored_word.to_s.gsub(/_id$/, "").gsub(/_/, " ").capitalize
    end

    # +constantize+ tries to find a declared constant with the name specified
    # in the string. It raises a NameError when the name is not in CamelCase
    # or is not initialized.
    #
    # Examples
    #   "Module".constantize # => Module
    #   "Class".constantize  # => Class
    def constantize
      _constantize(self)
    end
    
    # Tries to find a constant with the name specified in the argument string:
    #
    #   "Module".constantize     # => Module
    #   "Test::Unit".constantize # => Test::Unit
    #
    # The name is assumed to be the one of a top-level constant, no matter whether
    # it starts with "::" or not. No lexical context is taken into account:
    #
    #   C = 'outside'
    #   module M
    #     C = 'inside'
    #     C               # => 'inside'
    #     "C".constantize # => 'outside', same as ::C
    #   end
    #
    # NameError is raised when the name is not in CamelCase or the constant is
    # unknown.
    def _constantize(camel_cased_word)
      names = camel_cased_word.split('::')
      names.shift if names.empty? || names.first.empty?

      constant = Object
      names.each do |name|
        constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
      end
      constant
    end

  end
  
  String.send(:include, StringExtensions)
  Object.send(:include, ObjectExtensions)
end
