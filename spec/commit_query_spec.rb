require_relative 'spec_utils.rb'
require 'rspec'
require './lib/commit_query'

mock_hash = SpecUtils::MockResponse.commit_hash

describe 'CommitQuery' do
  let(:git_dbl){double(GitCommit)}

  before(:each) do
    allow(git_dbl).to receive(:commit_hash).and_return(mock_hash)
    allow(git_dbl).to receive(:score).and_return(SpecUtils::MockResponse.score)
    allow(git_dbl).to receive(:subject).and_return(SpecUtils::MockResponse.commit_message)
    allow(git_dbl).to receive(:branch_name).and_return(SpecUtils::MockResponse.branch_name)
    allow(git_dbl).to receive(:https_location).and_return(SpecUtils::MockResponse.repo_location)
    allow(git_dbl).to receive(:committer_email).and_return(SpecUtils::MockResponse.committer_email)
    allow(git_dbl).to receive(:files).and_return(SpecUtils::MockResponse.files)
    @commitQuery = CommitQuery.new(git_dbl)
  end

  context 'Without Commit Object' do
    it 'should raise an error' do
      expect {CommitQuery.new()}.to raise_error(ArgumentError)
    end
  end

  describe 'create_query' do
    context 'missing a commit hash' do
      it 'should raise an error' do
        allow(git_dbl).to receive(:commit_hash)
        expect {@commitQuery.create_query}.to raise_error(/commit hash/)
      end
    end

    context 'missing a score' do
      it 'should default score to 0' do
        allow(git_dbl).to receive(:score).and_return(nil)
        expect(@commitQuery.create_query).to include "score: 0"
      end
    end

    context 'with a good commit' do
      it 'should have a create statement' do
        expect(@commitQuery.create_query).to include "createCommit"
      end

      it 'should have a commit hash' do
        expect(@commitQuery.create_query).to include "repoCommitId: \"#{mock_hash}"
      end

      it 'should indicate the score' do
        expect(@commitQuery.create_query).to include "score: 3"
      end

      it 'should have a repo' do
        expect(@commitQuery.create_query).to include "uri: \"#{SpecUtils::MockResponse.repo_location}"
      end

      it 'should have an author' do
        expect(@commitQuery.create_query).to include "email: \"#{SpecUtils::MockResponse.committer_email}"
      end

      it 'should have a subject' do
        expect(@commitQuery.create_query).to include "commitMessage: \"#{SpecUtils::MockResponse.commit_message}"
      end

      it 'should have a branch' do
        expect(@commitQuery.create_query).to include "branch: \"#{SpecUtils::MockResponse.branch_name}"
      end

      it 'should have files' do
        expect(@commitQuery.create_query).to include "files: \"#{SpecUtils::MockResponse.files}"
      end


    end
  end

  describe 'publish_query' do
    context 'missing a commit hash' do
      it 'should raise an error' do
        allow(git_dbl).to receive(:commit_hash)
        expect {@commitQuery.publish_query}.to raise_error(/commit hash/)
      end
    end

    context 'with a good commit' do
      it 'should have a publish statement' do
        expect(@commitQuery.publish_query).to include "publishCommit"
      end

      it 'should have a commit hash' do
        expect(@commitQuery.publish_query).to include "repoCommitId: \"#{mock_hash}"
      end

    end
  end
end
