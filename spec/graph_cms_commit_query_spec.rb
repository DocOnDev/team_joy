require_relative 'spec_utils.rb'
require 'rspec'
require './lib/graph_cms_commit_query'

mock_hash = SpecUtils::MockResponse.commit_hash

describe 'GraphCmsCommitQuery' do
  let(:commit_dbl){double(Commit)}
  let(:author_dbl){double(Author)}

  before(:each) do
    allow(commit_dbl).to receive(:id).and_return(mock_hash)
    allow(commit_dbl).to receive(:score).and_return(SpecUtils::MockResponse.score)
    allow(commit_dbl).to receive(:subject).and_return(SpecUtils::MockResponse.commit_message)
    allow(commit_dbl).to receive(:body).and_return(SpecUtils::MockResponse.body)
    allow(commit_dbl).to receive(:branch_name).and_return(SpecUtils::MockResponse.branch_name)
    allow(commit_dbl).to receive(:https_location).and_return(SpecUtils::MockResponse.repo_location)
    allow(commit_dbl).to receive(:author).and_return(author_dbl)
    allow(commit_dbl).to receive(:files).and_return(SpecUtils::MockResponse.files)

    allow(author_dbl).to receive(:email).and_return(SpecUtils::MockResponse.committer_email)
    allow(author_dbl).to receive(:name).and_return(SpecUtils::MockResponse.committer_name)

    @commitQuery = GraphCmsCommitQuery.new(commit_dbl)
  end

  context 'Without Commit Object' do
    it 'should raise an error' do
      expect {GraphCmsCommitQuery.new()}.to raise_error(ArgumentError)
    end
  end

  describe 'create' do
    context 'missing a commit id' do
      it 'should raise an error' do
        allow(commit_dbl).to receive(:id)
        expect {@commitQuery.create}.to raise_error(/commit id/)
      end
    end

    context 'missing a score' do
      it 'should default score to 0' do
        allow(commit_dbl).to receive(:score).and_return(nil)
        expect(@commitQuery.create).to include "score: 0"
      end
    end

    context 'with a good commit' do
      it 'should have a create statement' do
        expect(@commitQuery.create).to include "createCommit"
      end

      it 'should have a commit hash' do
        expect(@commitQuery.create).to include "repoCommitId: \"#{mock_hash}"
      end

      it 'should indicate the score' do
        expect(@commitQuery.create).to include "score: 3"
      end

      it 'should have a repo' do
        expect(@commitQuery.create).to include "uri: \"#{SpecUtils::MockResponse.repo_location}"
      end

      it 'should have an author' do
        expect(@commitQuery.create).to include "email: \"#{SpecUtils::MockResponse.committer_email}"
      end

      it 'should have a subject' do
        expect(@commitQuery.create).to include "subject: \"#{SpecUtils::MockResponse.commit_message}"
      end

      it 'should have a body' do
        expect(@commitQuery.create).to include "body: \"#{SpecUtils::MockResponse.body}"
      end

      it 'should have a branch' do
        expect(@commitQuery.create).to include "branch: \"#{SpecUtils::MockResponse.branch_name}"
      end

      it 'should have files' do
        expect(@commitQuery.create).to include "committedFiles: #{SpecUtils::MockResponse.files}"
      end


    end
  end

  describe 'publish' do
    context 'missing a commit hash' do
      it 'should raise an error' do
        allow(commit_dbl).to receive(:id)
        expect {@commitQuery.publish}.to raise_error(/commit id/)
      end
    end

    context 'with a good commit' do
      it 'should have a publish statement' do
        expect(@commitQuery.publish).to include "publishCommit"
      end

      it 'should have a commit hash' do
        expect(@commitQuery.publish).to include "repoCommitId: \"#{mock_hash}"
      end

    end
  end
end
