require_relative 'spec_utils.rb'
require 'rspec'
require './lib/graph_cms'

mock_commit_hash = "Stubbed Commit Hash " + rand(10..1000).to_s
mock_commit_message = "Running Specs"
mock_repo_location = "git@github.com:DocOnDev/team_joy.git"
mock_committer_email = "test@docondev.com"
mock_committer_name = "Test User"
mock_commit_branch_name = "mock-branch"

describe 'GraphCMS' do
  let(:git_dbl){double(GitCommit)}

  before(:each) do
    allow(git_dbl).to receive(:commit_hash).and_return(mock_commit_hash)
    allow(git_dbl).to receive(:score).and_return(3)
    allow(git_dbl).to receive(:subject).and_return(mock_commit_message)
    allow(git_dbl).to receive(:branch_name).and_return(mock_commit_branch_name)
    allow(git_dbl).to receive(:https_location).and_return(mock_repo_location)
    allow(git_dbl).to receive(:committer_email).and_return(mock_committer_email)
    allow(git_dbl).to receive(:committer_name).and_return(mock_committer_name)
    @graph_cms = GraphCMS.new(git_dbl)
  end

  context 'Without Commit Object' do
    it 'should raise an error' do
      expect {GraphCMS.new()}.to raise_error(ArgumentError)
    end
  end

  describe 'query' do
    context 'missing a commit hash' do
      it 'should raise an error' do
        allow(git_dbl).to receive(:commit_hash)
        expect {@graph_cms.query}.to raise_error(/commit hash/)
      end
    end

    context 'missing a score' do
      it 'should default score to 0' do
        allow(git_dbl).to receive(:score).and_return(nil)
        expect(@graph_cms.query).to include "score: 0"
      end
    end

    context 'with a good commit' do
      it 'should have a createCommit query' do
        expect(@graph_cms.query).to include "createCommit"
      end

      it 'should have a publishCommit query' do
        expect(@graph_cms.query).to include "publishCommit"
      end

      it 'should have an upsertAuthor query' do
        expect(@graph_cms.query).to include "upsertAuthor"
      end

      it 'should have a publishAuthor query' do
        expect(@graph_cms.query).to include "publishAuthor"
      end

    end
  end

end
