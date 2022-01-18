require 'rspec'
require_relative 'spec_utils.rb'
require './lib/graph_cms_query_builder'
require './lib/empty_query_builder'

describe 'Query Builder Abstract Interface' do
  let(:commit_dbl){double(Commit)}
  let(:author_dbl){double(Author)}

  before(:each) do
    allow(commit_dbl).to receive(:id).and_return(SpecUtils::MockResponse.commit_hash)
    allow(commit_dbl).to receive(:score).and_return(SpecUtils::MockResponse.score)
    allow(commit_dbl).to receive(:subject).and_return(SpecUtils::MockResponse.commit_message)
    allow(commit_dbl).to receive(:body).and_return(SpecUtils::MockResponse.body)
    allow(commit_dbl).to receive(:branch_name).and_return(SpecUtils::MockResponse.branch_name)
    allow(commit_dbl).to receive(:uri).and_return(SpecUtils::MockResponse.https_location)
    allow(commit_dbl).to receive(:author).and_return(author_dbl)
    allow(commit_dbl).to receive(:files).and_return(SpecUtils::MockResponse.files)

    allow(author_dbl).to receive(:email).and_return(SpecUtils::MockResponse.committer_email)
    allow(author_dbl).to receive(:name).and_return(SpecUtils::MockResponse.committer_name)
  end

  context 'Implemented commit_query' do
    let(:builder){GraphCmsQueryBuilder.new}
    it 'should return a query string' do
      expect(builder.create_commit(commit_dbl)).to be_a(String)
    end
  end

  context 'Un-Implemented commit_query' do
    let(:builder){EmptyQueryBuilder.new}
    it 'should return an error' do
      expect {builder.create_commit(commit_dbl)}.to raise_error(AbstractInterface::InterfaceNotImplementedError, /needs to implement/)
    end
  end
end
