require_relative 'spec_utils.rb'
require 'rspec'
require './lib/author_query'

describe 'AuthorQuery' do
  let(:git_dbl){double(GitCommit)}

  before(:each) do
    allow(git_dbl).to receive(:committer_email).and_return(SpecUtils::MockResponse.committer_email)
    allow(git_dbl).to receive(:committer_name).and_return(SpecUtils::MockResponse.committer_name)
    @authorQuery = AuthorQuery.new(git_dbl)
  end

  context 'Without Commit Object' do
    it 'should raise an error' do
      expect {AuthorQuery.new()}.to raise_error(ArgumentError)
    end
  end

  describe 'upsert_query' do
    context 'missing an author email' do
      it 'should raise an error' do
        allow(git_dbl).to receive(:committer_email)
        expect {@authorQuery.upsert_query}.to raise_error(/author email/)
      end
    end

    context 'with a good commit' do
      it 'should have an upsert statement' do
        expect(@authorQuery.upsert_query).to include "upsertAuthor"
      end

      it 'should have an author email' do
        expect(@authorQuery.upsert_query).to include "email: \"#{SpecUtils::MockResponse.committer_email}"
      end

      it 'should have an author name' do
        expect(@authorQuery.upsert_query).to include "name: \"#{SpecUtils::MockResponse.committer_name}"
      end

      it 'should have an author create statement' do
        expect(@authorQuery.upsert_query).to include "create: { email: \"#{SpecUtils::MockResponse.committer_email}"
      end

      it 'should have an author update statement' do
        expect(@authorQuery.upsert_query).to include "update: { email: \"#{SpecUtils::MockResponse.committer_email}"
      end
    end
  end

  describe 'publish_query' do
    context 'missing an author email' do
      it 'should raise an error' do
        allow(git_dbl).to receive(:committer_email)
        expect {@authorQuery.publish_query}.to raise_error(/author email/)
      end
    end

    context 'with a good commit' do
      it 'should have a publish statement' do
        expect(@authorQuery.publish_query).to include "publishAuthor"
      end

      it 'should have an author email' do
        expect(@authorQuery.publish_query).to include "email: \"#{SpecUtils::MockResponse.committer_email}"
      end
    end
  end

end
