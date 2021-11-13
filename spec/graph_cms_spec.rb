require_relative 'spec_utils.rb'
require 'rspec'
require './lib/graph_cms'

describe 'GraphCMS' do
  context 'Without Commit Object' do
    it 'should raise an error' do
      expect {GraphCMS.new()}.to raise_error(ArgumentError)
    end
  end

  describe 'query' do
    context 'missing a commit hash' do
      it 'should raise an error' do
        git_commit_dbl = double(GitCommit)
        allow(git_commit_dbl).to receive(:commit_hash)
        graph_cms = GraphCMS.new(git_commit_dbl)
        expect {graph_cms.query}.to raise_error(/commit hash/)
      end
    end

    context 'with a commit hash' do
      it 'should return a valid query' do
        git_commit_dbl = double(GitCommit)
        allow(git_commit_dbl).to receive(:commit_hash).and_return("Stubbed Commit Hash")
        graph_cms = GraphCMS.new(git_commit_dbl)
        expect(graph_cms.query).to include "repoCommitId: \"Stubbed Commit Hash"
      end
    end
  end

end
