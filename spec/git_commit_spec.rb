require 'rspec'
require './lib/git_commit'

mock_log_response = '{"id":"'+SpecUtils::MockResponse.commit_hash+'","shortId":"80b0f9e","authorName":"'+SpecUtils::MockResponse.committer_name+'","committerName":"'+SpecUtils::MockResponse.committer_name+'","committerEmail":"'+SpecUtils::MockResponse.committer_email+'","subject":"Highly rated commit.","body":""}'
mock_files_response = "lib/git_commit.rb
lib/graph_query.rb
spec/git_commit_spec.rb
"


describe 'Git Commit' do
  let(:commit){GitCommit.new}
  let(:cli_dbl){double(CliRunner)}

  before(:each) do
    allow(cli_dbl).to receive(:run).with('git branch --show-current').and_return(SpecUtils::MockResponse.branch_name)
    allow(cli_dbl).to receive(:run).with("git config --get remote.origin.url").and_return(SpecUtils::MockResponse.repo_location)
    allow(cli_dbl).to receive(:run).with(/git log -1 HEAD/).and_return(mock_log_response)
    allow(cli_dbl).to receive(:run).with("git diff --name-only HEAD~1").and_return(mock_files_response)

    commit.cli_runner = cli_dbl
  end

  it 'should have a commit hash' do
    expect(commit.commit_hash).not_to be_nil
  end

  it 'should have a branch name' do
    expect(commit.branch_name).to eq(SpecUtils::MockResponse.branch_name)
  end

  it 'should have an author name' do
    expect(commit.author_name).to eq(SpecUtils::MockResponse.committer_name)
  end

  it 'should have an committer name' do
    expect(commit.committer_name).not_to be_nil
    expect(commit.committer_name).to eq(commit.author_name)
  end

  it 'should have an committer email' do
    expect(commit.committer_email).to eq(SpecUtils::MockResponse.committer_email)
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
    expect(commit.git_location).to match(/.*team_joy.git/)
  end

  it 'should have a valid https location' do
    expect(commit.https_location).to match(/https:\/\/.*team_joy/)
  end

end
