require 'spec_helper'

describe UserInput do
  describe UserInput::Prompt do
    let(:subject) do
      UserInput::Prompt.new(
        attempts: 2,
        message: '_msg',
        default: '_default'
      )
    end

    describe '#new' do
      it 'makes a new Prompt object' do
        expect(subject).to be_an_instance_of UserInput::Prompt
      end
    end

    describe '#ask' do
      it 'prompts for user input' do
        allow($stdin).to receive(:gets) { "_answer\n" }
        expect($stdout).to receive(:print).with('_msg? [_default] ')
        expect(subject.ask).to eql '_answer'
      end

      it 'returns the default if available' do
        allow($stdin).to receive(:gets) { "\n" }
        expect($stdout).to receive(:print).with('_msg? [_default] ')
        expect(subject.ask).to eql '_default'
      end

      context 'when provided a Regexp' do
        it 'validates input' do
          prompt = UserInput::Prompt.new(
            message: '_msg',
            validation: /[0-9]+/
          )
          allow($stdin).to receive(:gets).and_return("_str\n", "29\n")
          expect($stdout).to receive(:print).with('_msg? ').twice
          expect(prompt.ask).to eql '29'
        end
      end
      context 'when provided a code block' do
        it 'validates input' do
          prompt = UserInput::Prompt.new { |x| x == 'correct' }
          allow($stdin).to receive(:gets).and_return("_str\n", "correct\n")
          expect($stdout).to receive(:print).with('? ').twice
          expect(prompt.ask).to eql 'correct'
        end
      end
      context 'when provided an Enumerable' do
        it 'validates input' do
          prompt = UserInput::Prompt.new(
            message: '_msg',
            validation: %w[a b c]
          )
          allow($stdin).to receive(:gets).and_return("_str\n", "a\n")
          expect($stdout).to receive(:print).with('_msg? ').twice
          expect(prompt.ask).to eql 'a'
        end
      end
      context 'when provided an unsupported validation method' do
        it 'raises a RuntimeError' do
          prompt = UserInput::Prompt.new(validation: 28)
          allow($stdin).to receive(:gets).and_return("_str\n")
          expect($stdout).to receive(:print).with('? ')
          expect { prompt.ask }.to raise_error RuntimeError
        end
      end

      it 'raises an error if max attempts is reached' do
        prompt = UserInput::Prompt.new(attempts: 2) { false }
        allow($stdin).to receive(:gets).and_return("_str\n", "_foo\n")
        expect($stdout).to receive(:print).with('? ').twice
        expect { prompt.ask }.to raise_error ArgumentError
      end
    end

    it 'disables echo for secret input' do
      prompt = UserInput::Prompt.new(secret: true)
      allow($stdin).to receive(:gets).and_return("_str\n")
      expect($stdout).to receive(:print).with('? ')
      expect(prompt.ask).to eql '_str'
    end

    it 'accepts an alternate file descriptor for output' do
      target = StringIO.new
      prompt = UserInput::Prompt.new(fd: target)
      allow($stdin).to receive(:gets).and_return("_str\n")
      expect(target).to receive(:print).with('? ')
      expect(prompt.ask).to eql '_str'
    end
  end
end
