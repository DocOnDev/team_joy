require_relative 'spec_utils.rb'
require 'rspec'
require './lib/git_commit-msg_adapter'

describe 'Git Commit Message Adapter' do
  context "passed an invalid file" do
    let(:commit_file) {"bad_file_name.txt"}

    it "should report an argument error" do
      expect {GitCommitMessageAdapter.message_from_file(commit_file)}.to raise_error(ArgumentError, /not a valid file/)
    end
  end

  context "multi-Line commit message with valid score" do
    let(:commit_file) {SpecUtils::Resource.file("PassingWith3.txt")}
    let(:commit_file_with_4) {SpecUtils::Resource.file("PassingWith4.txt")}

    before(:each) do
      @commitMessage = GitCommitMessageAdapter.message_from_file(commit_file)
    end

    it "should have a valid score" do
      expect(@commitMessage.score).to eq(3)
      expect(GitCommitMessageAdapter.message_from_file(commit_file_with_4).score).to eq(4)
    end

    it "should have a valid subject" do
      expect(@commitMessage.subject).to eq("Highly rated commit.")
    end

    it "should have a single string message body" do
      expect(@commitMessage.body).to eq("Has some extra lines as well.\nWhy not?\n")
    end
  end

  context "single-line commit message with valid score" do
    let(:commit_file) {SpecUtils::Resource.file("PassingWith2.txt")}

    before(:each) do
      @commitMessage = GitCommitMessageAdapter.message_from_file(commit_file)
    end

    it "should have a valid score" do
      expect(@commitMessage.score).to eq(2)
    end

    it "should have a valid subject" do
      expect(@commitMessage.subject).to eq("Lowly rated commit.")
    end

    it "should have an empty message body" do
      expect(@commitMessage.body).to eq("")
    end
  end

  context "commit message without score" do
    let(:commit_file) {SpecUtils::Resource.file("FailingMissing.txt")}
    it 'should fail' do
      expect{ GitCommitMessageAdapter.message_from_file(commit_file) }.to raise_error(SystemExit, /between 0 and 5/)
    end
  end
end
