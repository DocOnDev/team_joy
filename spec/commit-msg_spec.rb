require_relative 'spec_utils.rb'
require 'rspec'
require './lib/commit-msg'

describe 'Commit Message Handler' do

  before(:each) do
    puts @resource_dir
    @checker = CheckCommit.new
    @file_name = SpecUtils::Resource.file("PassingWith3.txt")
  end

  it 'should tell me the file name' do
    output = SpecUtils::Capture.stdout { @checker.check @file_name }
    expect(output).to include "(#{@file_name})"
  end


  it 'should succeed when file content does contain commit pattern' do
    status = @checker.check @file_name
    expect(status).to eq(ExitCodes.success)
  end

  it 'should fail when file content does NOT contain commit pattern' do
    file_name = SpecUtils::Resource.file("FailingMissing.txt")
    status = @checker.check file_name
    expect(status).to eq(ExitCodes.fail)
  end

  it 'should fail when file content contains pattern with value over 5' do
    file_name = SpecUtils::Resource.file("FailingWith6.txt")
    status = @checker.check file_name
    expect(status).to eq(ExitCodes.fail)
  end

end