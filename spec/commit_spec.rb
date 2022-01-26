require_relative 'spec_utils.rb'
require 'rspec'
require './lib/commit'

describe 'Commit' do
  let(:commit){Commit.new}

  context "ID Property" do
    it 'should reject a non-String value' do
      expect do
        output = SpecUtils::Capture.stdout { commit.id = 42 }
        expect(output).to include "A commit id must be a String"
      end.to raise_error(SystemExit)
    end

    it 'should accept a String value' do
      commit.id = "String ID"
      expect(commit.id).to eq("String ID")
    end
  end
end
