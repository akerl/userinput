module UserInput
  ##
  # Helper class for asking yes/no questions
  class Boolean < Prompt
    def initialize(params = {})
      super
      @validation = /(y|yes|n|no)/i
      @separator = ' [y/n]?' if @separator == '?'
    end

    def ask
      super =~ /y/i ? true : false
    end
  end
end
