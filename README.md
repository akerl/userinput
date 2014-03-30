userinput
=========

[![Gem Version](https://img.shields.io/gem/v/userinput.svg)](https://rubygems.org/gems/userinput)
[![Dependency Status](https://img.shields.io/gemnasium/akerl/userinput.svg)](https://gemnasium.com/akerl/userinput)
[![Code Climate](https://img.shields.io/codeclimate/github/akerl/userinput.svg)](https://codeclimate.com/github/akerl/userinput)
[![Coverage Status](https://img.shields.io/coveralls/akerl/userinput.svg)](https://coveralls.io/r/akerl/userinput)
[![Build Status](https://img.shields.io/travis/akerl/userinput.svg)](https://travis-ci.org/akerl/userinput)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

A simple user input library

## Usage

User interaction is handled by the `UserInput::Prompt` object. As a convenience, this can be created using the `UserInput.new` method:

```
> require 'userinput'
=> true
> prompt = UserInput.new(message: 'Username')
=> #<UserInput::Prompt:0x007fdfba1681f8 @attempts=nil, @message="Username", @default=nil, @secret=false, @validation=nil>
> prompt.ask
Username? leet_dude
=> "leet_dude"
```

You can optionally provide a default:

```
> require 'userinput'
=> true
> prompt = UserInput.new(default: '_other')
=> #<UserInput::Prompt:0x007fb7eb163f00 @attempts=nil, @message="", @default="_other", @secret=false, @validation=nil>
> prompt.ask
? [_other] answer
=> "answer"
> prompt.ask
? [_other]
=> "_other"
```

If you provide a validation Regexp or a code block, the input will be validated using that:

```
> require 'userinput'
=> true
> prompt = UserInput.new(validation: /[0-9]+/)
=> #<UserInput::Prompt:0x007f99909637b0 @attempts=nil, @message="", @default=nil, @secret=false, @validation=/[0-9]+/>
> prompt.ask
? _str
? 23
=> "23"
> other_prompt = UserInput.new { |x| x == '_correct' }
=> #<UserInput::Prompt:0x007f9990920eb0 @attempts=nil, @message="", @default=nil, @secret=false, @validation=#<Proc:0x007f99909211d0@(irb):4>>
> other_prompt.ask
? _wrong
? 23
? _correct
=> "_correct"
```

Providing a number of attempts will cause an ArgumentError to be raised after that many failed inputs:

```
> require 'userinput'
=> true
> prompt = UserInput.new(attempts: 3, validation: /[0-9]+/)
=> #<UserInput::Prompt:0x007f9f6a950270 @attempts=3, @message="", @default=nil, @secret=false, @validation=/[0-9]+/>
> prompt.ask
? _str
? _other
? _attempt
ArgumentError: No valid input provided
```

For sensitive input, pass the `secret` parameter, which will try to disable terminal printing of the user's input:

```
> require 'userinput'
=> true
> prompt = UserInput.new(message: 'Password', secret: true)
=> #<UserInput::Prompt:0x007fb8ab9220a0 @attempts=nil, @message="Password", @default=nil, @secret=true, @validation=nil>
> prompt.ask
Password?
=> "_password"
```

## Installation

    gem install userinput

## License

userinput is released under the MIT License. See the bundled LICENSE file for details.

