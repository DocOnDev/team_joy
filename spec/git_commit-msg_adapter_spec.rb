require_relative 'spec_utils.rb'
require 'rspec'
require './lib/git_commit-msg_adapter'

describe 'Git Commit Message Adapter' do
  context "passed an invalid file" do
    let(:commit_file) {"bad_file_name.txt"}

    it "should report an argument error" do
      adapter = GitCommitMessageAdapter.new
      expect {adapter.message_from_file(commit_file)}.to raise_error(ArgumentError, /not a valid file/)
    end
  end

  context "multi-Line commit message with valid score" do
    let(:commit_file) {SpecUtils::Resource.file("PassingWith3.txt")}
    let(:commit_file_with_4) {SpecUtils::Resource.file("PassingWith4.txt")}

    before(:each) do
      @adapter = GitCommitMessageAdapter.new
      @commitMessage = @adapter.message_from_file(commit_file)
    end

    it "should have a valid score" do
      expect(@commitMessage.score).to eq(3)
      expect(@adapter.message_from_file(commit_file_with_4).score).to eq(4)
    end

  end
end
