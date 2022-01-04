require_relative 'spec_utils.rb'
require 'rspec'
require './lib/commit_message_writer'

COMMIT_MESSAGE_FILE = File.expand_path(File.dirname(__FILE__)) + "/COMMIT_MSG_FILE"

describe 'Commit Message Writer' do
  context 'given no commit message' do
    it 'should throw an argument error' do
      expect {CommitMessageWriter.new}.to raise_error(ArgumentError)
    end
  end

  context 'given a commit message with a subject and body' do
    let(:writer){CommitMessageWriter.new(@message)}
    SUBJECT = "This is the subject line with a body"
    BODY = "This is the body line one.\nThis is the body line two."
    before(:each) do
      @message = CommitMessage.new
      @message.subject = SUBJECT
      @message.body = BODY
    end

    it 'should write the subject and body' do
      writer.write_to_file(COMMIT_MESSAGE_FILE)

      content = File.readlines(COMMIT_MESSAGE_FILE)
      expect(content[0].chomp).to eq(SUBJECT)
      lines = BODY.split("\n")
      expect(content[1].chomp).to eq(lines[0])
      expect(content[2].chomp).to eq(lines[1])
    end
  end

  context 'given a commit message with only a subject' do
    let(:writer){CommitMessageWriter.new(@message)}
    SUBJECT = "This is the solo subject line"
    before(:each) do
      @message = CommitMessage.new
      @message.subject = SUBJECT
    end

    it 'should write the subject and no body' do
      writer.write_to_file(COMMIT_MESSAGE_FILE)

      content = File.readlines(COMMIT_MESSAGE_FILE)
      expect(content[0].chomp).to eq(SUBJECT)
      expect(content[1]).to be_nil
    end
  end

end
