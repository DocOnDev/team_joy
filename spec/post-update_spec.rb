require 'rspec'
require './lib/post-update'

describe 'Git Information' do
  let(:git_info){GitCommit.new}

  it 'should have a commit hash' do
    expect(git_info.commit_hash).not_to be_nil
  end

  it 'should have a short commit hash' do
    expect(git_info.short_commit_hash).not_to be_nil
    expect(git_info.commit_hash).to include(git_info.short_commit_hash)
  end

  it 'should have a branch name' do
    expect(git_info.branch_name).not_to be_nil
  end

  it 'should have a branch hash' do
    expect(git_info.branch_hash).not_to be_nil
  end

  it 'should have an author name' do
    expect(git_info.author_name).not_to be_nil
  end

  it 'should have an committer name' do
    expect(git_info.committer_name).not_to be_nil
    expect(git_info.committer_name).to eq(git_info.author_name)
  end

  it 'should have an committer email' do
    expect(git_info.committer_email).not_to be_nil
  end

  it 'should have a committer email that matches a basic email pattern' do
    expect(git_info.committer_email).to match(/[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+/)
  end

  it 'should have a subject' do
    expect(git_info.subject).not_to be_nil
  end

  it 'should have a body' do
    expect(git_info.body).not_to be_nil
  end

  it 'should have at least one file' do
    expect(git_info.files.size).to be > 0
  end

  it 'should have a valid git location' do
    expect(git_info.git_location).to match(/.*team_joy.git/)
  end

  it 'should have a valid https location' do
    expect(git_info.https_location).to match(/https:\/\/.*team_joy/)
  end

end
