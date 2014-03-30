require 'spec_helper'

describe UserInput do
  describe '#new' do
    it 'creates Prompt objects' do
      expect(UserInput.new).to be_an_instance_of UserInput::Prompt
    end
  end

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
        allow(STDIN).to receive(:gets) { "_answer\n" }
        expect(subject).to receive(:print).with('_msg? [_default] ')
        expect(subject.ask).to eql '_answer'
      end

      it 'returns the default if available' do
        allow(STDIN).to receive(:gets) { "\n" }
        expect(subject).to receive(:print).with('_msg? [_default] ')
        expect(subject.ask).to eql '_default'
      end

      context 'when provided a Regexp' do
        it 'validates input' do
          prompt = UserInput::Prompt.new(
            message: '_msg',
            validation: /[0-9]+/
          )
          allow(STDIN).to receive(:gets).and_return("_str\n", "29\n")
          expect(prompt).to receive(:print).with('_msg? ').twice
          expect(prompt.ask).to eql '29'
        end
      end
      context 'when provided a code block' do
        it 'validates input' do
          prompt = UserInput::Prompt.new { |x| x == 'correct' }
          allow(STDIN).to receive(:gets).and_return("_str\n", "correct\n")
          expect(prompt).to receive(:print).with('? ').twice
          expect(prompt.ask).to eql 'correct'
        end
      end

      it 'raises an error if max attempts is reached' do
        prompt = UserInput::Prompt.new(attempts: 2) { |x| false }
        allow(STDIN).to receive(:gets).and_return("_str\n", "_foo\n")
        expect(prompt).to receive(:print).with('? ').twice
        expect { prompt.ask }.to raise_error ArgumentError
      end
    end
  end
end
