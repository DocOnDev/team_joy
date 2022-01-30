require_relative 'spec_utils.rb'
require 'rspec'
require './lib/commit_message'

describe 'Commit Message' do
  let(:commitMessage){CommitMessage.new}

  context "Subject Property" do
    it 'should reject a non-String value' do
      expect{ commitMessage.subject = 42 }.to raise_error(ArgumentError, /must be of type String/)
    end

    it 'should accept a String value' do
      commitMessage.subject = "String Subject"
      expect(commitMessage.subject).to eq("String Subject")
    end
  end

  context "Score Property" do
    it 'should reject a non-Integer value' do
      expect{ commitMessage.score = "Big Score" }.to raise_error(ArgumentError, /must be of type Integer/)
    end

    it 'should reject an Integer value less than 0' do
      expect{ commitMessage.score = -1 }.to raise_error(ArgumentError, /between 0 and 5/)
    end

    it 'should reject an Integer value greater than 5' do
      expect{ commitMessage.score = 6 }.to raise_error(ArgumentError, /between 0 and 5/)
    end

    it 'should accept an Integer value between 0 and 5' do
      commitMessage.score = 3
      expect(commitMessage.score).to eq(3)
    end
  end

  context "Body Property" do
    it 'should reject a non-String value' do
      expect{ commitMessage.body = [6] }.to raise_error(ArgumentError, /must be of type String/)
    end

    it 'should accept a String value' do
      commitMessage.body = "This is the message body"
      expect(commitMessage.body).to eq("This is the message body")

    end
  end
end
