require_relative 'spec_utils.rb'
require 'rspec'
require './lib/commit-msg'


describe 'Commit Message Handler' do

  it 'should tell me the file name' do
    checker = CheckCommit.new
    file_name = 'FileName.txt'
    output = SpecUtils::Capture.stdout { checker.check file_name }
    expect(output).to include "(#{file_name})"
  end


end
