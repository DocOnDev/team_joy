require 'rspec'
require './lib/post-update'

describe 'Git Information' do
  let(:git_info){GitCommit.new}

  it 'should have a branch name' do
    expect(git_info.branch_name).not_to be_nil
  end

  it 'should have a branch hash' do
    expect(git_info.branch_hash).not_to be_nil
  end

  it 'should have a valid git location' do
    expect(git_info.git_location).to match(/.*team_joy.git/)
  end

  it 'should have a valid https location' do
    expect(git_info.https_location).to match(/https:\/\/.*team_joy/)
  end

end
