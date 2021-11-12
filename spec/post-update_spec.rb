require 'rspec'
require './lib/post-update'

describe 'Git Information' do
  let(:commit){GitCommit.new}

  it 'should have a commit hash' do
    expect(commit.commit_hash).not_to be_nil
  end

  it 'should have a short commit hash' do
    expect(commit.short_commit_hash).not_to be_nil
    expect(commit.commit_hash).to include(commit.short_commit_hash)
  end

  it 'should have a branch name' do
    expect(commit.branch_name).not_to be_nil
  end

  it 'should have a branch hash' do
    expect(commit.branch_hash).not_to be_nil
  end

  it 'should have an author name' do
    expect(commit.author_name).not_to be_nil
  end

  it 'should have an committer name' do
    expect(commit.committer_name).not_to be_nil
    expect(commit.committer_name).to eq(commit.author_name)
  end

  it 'should have an committer email' do
    expect(commit.committer_email).not_to be_nil
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

  it 'should have at least one file' do
    expect(commit.files.size).to be > 0
  end

  it 'should have a valid git location' do
    expect(commit.git_location).to match(/.*team_joy.git/)
  end

  it 'should have a valid https location' do
    expect(commit.https_location).to match(/https:\/\/.*team_joy/)
  end

end
