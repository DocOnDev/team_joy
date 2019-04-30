require_relative 'spec_utils.rb'
require 'rspec'
require './lib/commit-msg'


describe 'Commit Message Handler' do

  before(:each) do
    @checker = CheckCommit.new
  end

  it 'should succeed when file content does contain commit pattern' do
    file_name = "resouces/PassingFile.txt"
    status = @checker.check file_name
    expect(status).to eq(ExitCodes.success)
  end


  it 'should tell me the file name' do
    file_name = 'FileName.txt'
    output = SpecUtils::Capture.stdout { @checker.check file_name }
    expect(output).to include "(#{file_name})"
  end


end
