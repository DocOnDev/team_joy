require_relative 'spec_utils.rb'
require 'rspec'
require './lib/commit_score_writer'
require './lib/joy_config'

SUBJECT = "This is the subject line without a body"
SCORE = 5

describe 'Commit Score Writer' do
  context 'given no commit message' do
    it 'should throw an argument error' do
      expect {CommitScoreWriter.write}.to raise_error(ArgumentError)
    end
  end

  context 'given a commit message with a subject and score' do
    before(:each) do
      @message = CommitMessage.new
      @message.subject = SUBJECT
      @message.score = SCORE
    end

    it 'should write a subject and score' do
      CommitScoreWriter.write(@message)
      expect(get_scores[SUBJECT]).to eq(SCORE)
    end
  end
end

def get_scores
  config = JoyConfig.new
  file = File.read(config.score_file_name)
  JSON.parse(file)
end
