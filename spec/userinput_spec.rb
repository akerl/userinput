require 'spec_helper'

describe UserInput do
  describe '#new' do
    it 'creates Prompt objects' do
      expect(UserInput.new).to be_an_instance_of UserInput::Prompt
    end
  end
end
