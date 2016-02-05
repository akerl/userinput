##
# User input library
module UserInput
  class << self
    ##
    # Insert a helper .new() method for creating a new Prompt object

    def new(*args, &block)
      self::Prompt.new(*args, &block)
    end
  end

  ##
  # Prompt object
  class Prompt
    ##
    # Build new prompt object and set defaults
    def initialize(params = {}, &block)
      @attempts = params[:attempts]
      @message = params[:message] || ''
      @default = params[:default]
      @secret = params[:secret] || false
      @validation = block || params[:validation]
    end

    ##
    # Request user input
    def ask
      print "#{@message}? #{@default.nil? ? '' : "[#{@default}] "}"
      disable_echo if @secret

      input = _ask
      return input if valid(input)

      check_counter
      ask
    ensure
      enable_echo if @secret
    end

    private

    ##
    # Validate user input
    def valid(input)
      case @validation
      when Proc
        return @validation.call input
      when Regexp
        return @validation.match input
      when NilClass
        return true
      else
        raise "Supported validation type not provided #{@validation.class}"
      end
    end

    ##
    # Parse user input
    def _ask
      input = STDIN.gets.chomp
      input = @default if input.empty? && @default
      puts if @secret
      input
    end

    ##
    # Track attempt counter
    def check_counter
      return if @attempts.nil?
      @attempts -= 1
      raise ArgumentError, 'No valid input provided' if @attempts == 0
    end

    ##
    # Disable terminal display of user input
    def disable_echo
      toggle_echo false
    end

    ##
    # Enable terminal display of user input
    def enable_echo
      toggle_echo true
    end

    ##
    # Toggle terminal display of user input
    def toggle_echo(state)
      setting = state ? '' : '-'
      `stty #{setting}echo`
    rescue
      nil
    end
  end
end
