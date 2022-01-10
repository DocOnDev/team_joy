require 'rspec'
require './lib/git_commit_adapter'

describe 'Git Commit Adapter' do
  let(:git_commit_dbl){double(GitCommit)}

  before(:each) do
    allow(git_commit_dbl).to receive(:commit_hash).and_return(SpecUtils::MockResponse.commit_hash)
    allow(git_commit_dbl).to receive(:files).and_return(SpecUtils::MockResponse.files)
    allow(git_commit_dbl).to receive(:subject).and_return(SpecUtils::MockResponse.commit_message)
    allow(git_commit_dbl).to receive(:body).and_return(SpecUtils::MockResponse.body)
    allow(git_commit_dbl).to receive(:score).and_return(SpecUtils::MockResponse.score)
    allow(git_commit_dbl).to receive(:branch_name).and_return(SpecUtils::MockResponse.branch_name)
    allow(git_commit_dbl).to receive(:committer_name).and_return(SpecUtils::MockResponse.committer_name)
    allow(git_commit_dbl).to receive(:committer_email).and_return(SpecUtils::MockResponse.committer_email)

    @commit = GitCommitAdapter.transform_commit(git_commit_dbl)
  end

  it 'should transform a hash into an id' do
    expect(@commit.id).to eq(SpecUtils::MockResponse.commit_hash)
  end

  it 'should transform a file array into a string' do
    expect(@commit.files).to eq(SpecUtils::MockResponse.files.to_s)
  end

  it 'should transform the committer into an Author' do
    actual = @commit.author
    expected = Author.new(SpecUtils::MockResponse.committer_name, SpecUtils::MockResponse.committer_email)
    expect(actual).to eq(expected)
  end
end
