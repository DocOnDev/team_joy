require_relative 'spec_utils.rb'
require 'rspec'
require './lib/graph_cms_query_builder'

describe 'GraphCmsQueryBuilder' do
  let(:commit_dbl){double(Commit)}
  let(:author_dbl){double(Author)}

  before(:each) do
    allow(commit_dbl).to receive(:id).and_return(SpecUtils::MockResponse.commit_hash)
    allow(commit_dbl).to receive(:score).and_return(SpecUtils::MockResponse.commit_score)
    allow(commit_dbl).to receive(:subject).and_return(SpecUtils::MockResponse.commit_message)
    allow(commit_dbl).to receive(:body).and_return(SpecUtils::MockResponse.body)
    allow(commit_dbl).to receive(:branch_name).and_return(SpecUtils::MockResponse.branch_name)
    allow(commit_dbl).to receive(:uri).and_return(SpecUtils::MockResponse.https_location)
    allow(commit_dbl).to receive(:files).and_return(SpecUtils::MockResponse.files)

    allow(commit_dbl).to receive(:author).and_return(author_dbl)
    allow(author_dbl).to receive(:email).and_return(SpecUtils::MockResponse.committer_email)
    allow(author_dbl).to receive(:name).and_return(SpecUtils::MockResponse.committer_name)

    @graph_query = GraphCmsQueryBuilder.new
  end

  describe 'create_commit' do
    context 'missing a commit id' do
      it 'should raise an error' do
        allow(commit_dbl).to receive(:id)
        expect {@graph_query.create_commit(commit_dbl)}.to raise_error(/commit id/)
      end
    end

    context 'missing a score' do
      it 'should default score to 0' do
        allow(commit_dbl).to receive(:score).and_return(nil)
        expect(@graph_query.create_commit(commit_dbl)).to include "score: 0"
      end
    end

    context 'with a good commit' do
      it 'should have a createCommit query' do
        expect(@graph_query.create_commit(commit_dbl)).to include "createCommit"
      end

      it 'should have a publishCommit query' do
        expect(@graph_query.create_commit(commit_dbl)).to include "publishCommit"
      end

      it 'should have an upsertAuthor query' do
        expect(@graph_query.create_commit(commit_dbl)).to include "upsertAuthor"
      end

      it 'should have a publishAuthor query' do
        expect(@graph_query.create_commit(commit_dbl)).to include "publishAuthor"
      end

    end
  end

end
