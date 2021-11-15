require_relative 'spec_utils.rb'
require 'rspec'
require './lib/commit-msg'

describe 'Commit Message Handler' do
  let(:output_dir_name) { './lib' }
  let(:checker) {CheckCommit.new}
  let(:commit_file_name) {SpecUtils::Resource.file("PassingWith3.txt")}

  it 'should tell me the file name' do
    output = SpecUtils::Capture.stdout { checker.check commit_file_name }
    expect(output).to include "(#{commit_file_name})"
  end


  context 'file content does contain commit pattern' do
    it 'should succeed' do
      status = checker.check commit_file_name
      expect(status).to eq(ExitCodes.success)
    end

    context 'TJ_SCORES file does not exist' do
      it 'should create the TJ_SCORES file' do
        File.delete(output_dir_name + 'TJ_SCORES') if File.exist?(output_dir_name + 'TJ_SCORES')
        status = checker.check commit_file_name
        expect(File.exist?("#{output_dir_name}/TJ_SCORES")).to be true
      end
    end

  end

  context 'file content does NOT contain commit pattern' do
    it 'should fail' do
      commit_file_name = SpecUtils::Resource.file("FailingMissing.txt")
      content = File.readlines commit_file_name

      expect do
        output = SpecUtils::Capture.stdout { checker.check commit_file_name }
        expect(output).to include "Commit rejected: Message #{content} does not contain a rating between 0 and 5."
      end.to raise_error(SystemExit)
    end
  end

  context 'file content contains pattern with value over 5' do
    it 'should fail' do
      commit_file_name = SpecUtils::Resource.file("FailingWith6.txt")
      expect { checker.check commit_file_name }.to raise_error(SystemExit)
    end
  end

end
