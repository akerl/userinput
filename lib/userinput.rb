##
# User input library
module UserInput
  # Hash of validation strategies
  VALIDATIONS = {
    Proc => :call,
    Regexp => :match,
    Enumerable => :include?
  }.freeze

  class << self
    ##
    # Insert a helper .new() method for creating a new Prompt object

    def new(*args, &block)
      self::Prompt.new(*args, &block)
    end
  end
end

require 'userinput/prompt'
require 'userinput/boolean'
