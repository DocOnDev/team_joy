require_relative 'spec_utils.rb'
require 'rspec'
require './lib/commit-msg'

describe 'Commit Message Handler' do
  let(:dirname) { './lib' }

  before(:each) do
    puts @resource_dir
    @checker = CheckCommit.new
    @file_name = SpecUtils::Resource.file("PassingWith3.txt")
  end

  it 'should tell me the file name' do
    output = SpecUtils::Capture.stdout { @checker.check @file_name }
    expect(output).to include "(#{@file_name})"
  end


  context 'file content does contain commit pattern' do
    it 'should succeed' do
      status = @checker.check @file_name
      expect(status).to eq(ExitCodes.success)
    end

    context 'TJ_SCORES file does not exist' do
      before(:each) do
        puts "Directory Name: #{dirname}"
        File.delete(dirname + 'TJ_SCORES') if File.exist?(dirname + 'TJ_SCORES')
      end
      it 'should create the TJ_SCORES file' do
        status = @checker.check @file_name
        expect(File.exist?("#{dirname}/TJ_SCORES")).to be true
      end
    end

  end

  context 'file content does NOT contain commit pattern' do
    it 'should fail' do
      file_name = SpecUtils::Resource.file("FailingMissing.txt")
      content = File.readlines file_name

      expect do
        output = SpecUtils::Capture.stdout { @checker.check file_name }
        expect(output).to include "Commit rejected: Message #{content} does not contain a rating between 0 and 5."
      end.to raise_error(SystemExit)
    end
  end

  context 'file content contains pattern with value over 5' do
    it 'should fail' do
      file_name = SpecUtils::Resource.file("FailingWith6.txt")
      expect { @checker.check file_name }.to raise_error(SystemExit)
    end
  end

end
