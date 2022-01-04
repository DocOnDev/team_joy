require_relative 'spec_utils.rb'
require 'rspec'
require './lib/commit_message_writer'
require './lib/commit_message'

COMMIT_MESSAGE_FILE = File.expand_path(File.dirname(__FILE__)) + "/COMMIT_MSG_FILE"
BODY = "This is the body line one.\nThis is the body line two."

describe 'Commit Message Writer' do
  context 'given no commit message' do
    it 'should throw an argument error' do
      expect {CommitMessageWriter.new}.to raise_error(ArgumentError)
    end
  end

  context 'given a commit message with a subject and body' do
    let(:writer){CommitMessageWriter.new(@message)}

    before(:each) do
      @message = CommitMessage.new
      @subject = "This is the subject line with a body"
      @message.subject = @subject
      @message.body = BODY
    end

    it 'should write the subject and body' do
      writer.write_to_file(COMMIT_MESSAGE_FILE)

      content = File.readlines(COMMIT_MESSAGE_FILE)
      expect(content[0].chomp).to eq(@subject)
      lines = BODY.split("\n")
      expect(content[1]).to eq("\n")
      expect(content[2].chomp).to eq(lines[0])
      expect(content[3].chomp).to eq(lines[1])
    end
  end

  context 'given a commit message with only a subject' do
    let(:writer){CommitMessageWriter.new(@message)}

    before(:each) do
      @message = CommitMessage.new
      @subject = "This is the solo subject line"
      @message.subject = @subject
    end

    it 'should write the subject and no body' do
      writer.write_to_file(COMMIT_MESSAGE_FILE)

      content = File.readlines(COMMIT_MESSAGE_FILE)
      expect(content[0].chomp).to eq(@subject)
      expect(content[1]).to eq("\n")
      expect(content[2]).to be_nil

    end
  end

end
