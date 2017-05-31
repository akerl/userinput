module UserInput
  MESSAGE_TEMPLATE = '%<message>s%<separator>s %<default>s'.freeze

  ##
  # Prompt object
  class Prompt
    ##
    # Build new prompt object and set defaults
    def initialize(params = {}, &block)
      @attempts = params[:attempts]
      @message = params[:message] || ''
      @separator = params[:separator] || '?'
      @default = params[:default]
      @secret = params[:secret] || false
      @fd = params[:fd] || STDOUT
      @validation = block || params[:validation]
    end

    ##
    # Request user input
    def ask
      @fd.print full_message
      disable_echo if @secret

      input = _ask
      return input if valid(input)

      check_counter
      ask
    ensure
      enable_echo if @secret
    end

    private

    def full_message
      MESSAGE_TEMPLATE % {
        message: @message,
        separator: @separator,
        default: @default.nil? ? '' : "[#{@default}] "
      }
    end

    ##
    # Validate user input
    def valid(input)
      return true unless @validation
      _, method = VALIDATIONS.find { |klass, _| @validation.is_a? klass }
      return @validation.send(method, input) if method
      raise "Supported validation type not provided #{@validation.class}"
    end

    ##
    # Parse user input
    def _ask
      input = STDIN.gets.chomp
      input = @default if input.empty? && @default
      @fd.puts if @secret
      input
    end

    ##
    # Track attempt counter
    def check_counter
      return if @attempts.nil?
      @attempts -= 1
      raise ArgumentError, 'No valid input provided' if @attempts.zero?
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
