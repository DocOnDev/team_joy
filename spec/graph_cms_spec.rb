require_relative 'spec_utils.rb'
require 'rspec'
require './lib/graph_cms'

MOCK_COMMIT_HASH = "Stubbed Commit Hash " + rand(10..1000).to_s
MOCK_COMMIT_MESSAGE = "Running Specs"

describe 'GraphCMS' do
  let(:git_dbl){double(GitCommit)}

  before(:each) do
    allow(git_dbl).to receive(:commit_hash).and_return(MOCK_COMMIT_HASH)
    allow(git_dbl).to receive(:score).and_return(3)
    allow(git_dbl).to receive(:subject).and_return(MOCK_COMMIT_MESSAGE)
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
      it 'should indicate the score' do
        expect(@graph_cms.query).to include "score: 3"
      end

      it 'should have a subject' do
        expect(@graph_cms.query).to include "commitMessage: \"#{MOCK_COMMIT_MESSAGE}"
      end

      it 'should have a commit hash' do
        expect(@graph_cms.query).to include "repoCommitId: \"#{MOCK_COMMIT_HASH}"
      end
    end
  end

end
