require 'rspec'
require './lib/git_commit'

MOCK_BRANCH_NAME = 'test_branch-234'
MOCK_HASH = 'FAKE-HASH-453453455'
MOCK_REPO_LOCATION = "git@github.com:DocOnDev/TEST_team_joy.git"
MOCK_AUTHOR_NAME = "Doc Norton"
MOCK_AUTHOR_EMAIL = "doc@docondev.com"
MOCK_LOG_RESPONSE = '{"id":"80b0f9e8f0062c2ccee0ad246a2a983230122cf6","shortId":"80b0f9e","authorName":"'+MOCK_AUTHOR_NAME+'","committerName":"'+MOCK_AUTHOR_NAME+'","committerEmail":"'+MOCK_AUTHOR_EMAIL+'","subject":"-1- Roll-back while working on GitCommit","body":""}'
MOCK_FILES_RESPONSE = "lib/git_commit.rb
lib/graph_cms.rb
spec/git_commit_spec.rb
"


describe 'Git Commit' do
  let(:commit){GitCommit.new}
  let(:cli_dbl){double(CliRunner)}

  before(:each) do
    allow(cli_dbl).to receive(:run).with('git branch --show-current').and_return('test_branch-234')
    allow(cli_dbl).to receive(:run).with('git branch --show-current').and_return(MOCK_BRANCH_NAME)
    allow(cli_dbl).to receive(:run).with("git config --get remote.origin.url").and_return(MOCK_REPO_LOCATION)
    allow(cli_dbl).to receive(:run).with(/git log -1 HEAD/).and_return(MOCK_LOG_RESPONSE)
    allow(cli_dbl).to receive(:run).with("git diff --name-only HEAD~1").and_return(MOCK_FILES_RESPONSE)
    commit.cli_runner = cli_dbl

  end

  it 'should have a commit hash' do
    expect(commit.commit_hash).not_to be_nil
  end

  it 'should have a short commit hash' do
    expect(commit.short_commit_hash).not_to be_nil
    expect(commit.commit_hash).to include(commit.short_commit_hash)
  end

  it 'should have a branch name' do
    expect(commit.branch_name).to eq('test_branch-234')
  end

  it 'should have a branch hash' do
    allow(cli_dbl).to receive(:run).with("git rev-parse #{MOCK_BRANCH_NAME}").and_return(MOCK_HASH)
    expect(commit.branch_hash).to eq(MOCK_HASH)
  end

  it 'should have an author name' do
    expect(commit.author_name).to eq(MOCK_AUTHOR_NAME)
  end

  it 'should have an committer name' do
    expect(commit.committer_name).not_to be_nil
    expect(commit.committer_name).to eq(commit.author_name)
  end

  it 'should have an committer email' do
    expect(commit.committer_email).to eq(MOCK_AUTHOR_EMAIL)
  end

  it 'should have a committer email that matches a basic email pattern' do
    expect(commit.committer_email).to match(/[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+/)
  end

  it 'should have a subject' do
    expect(commit.subject).not_to be_nil
  end

  it 'should have a body' do
    expect(commit.body).not_to be_nil
  end

  it 'should have 3 files' do
    expect(commit.files.size).to eq(3)
  end

  it 'should have a valid git location' do
    expect(commit.git_location).to match(/.*TEST_team_joy.git/)
  end

  it 'should have a valid https location' do
    expect(commit.https_location).to match(/https:\/\/.*TEST_team_joy/)
  end

end
