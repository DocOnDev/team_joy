require_relative 'spec_utils.rb'
require 'rspec'
require './lib/commit-msg'

describe 'Commit Message Handler' do
  let(:output_dir_name) { './lib' }
  let(:checker) {CheckCommit.new}
  let(:preserve_file) {SpecUtils::Resource.file("PassingWith3.txt")}
  let(:commit_file_name) {SpecUtils::Resource.file("PassingWith3.txt2")}

  it 'should tell me the file name' do
    output = SpecUtils::Capture.stdout { checker.check commit_file_name }
    expect(output).to include "(#{commit_file_name})"
  end


  context 'file content does contain commit pattern' do
    before(:each) do
      FileUtils.copy(preserve_file, commit_file_name)
      @score_file_name = "#{output_dir_name}/TJ_SCORES"
    end

    it 'should succeed' do
      status = checker.check commit_file_name
      expect(status).to eq(ExitCodes.success)
    end

    it 'should remove the score from the commit message subject' do
      status = checker.check commit_file_name
      file_content = File.readlines(commit_file_name)
      expect(file_content.grep(/\-[0-5]\-/).none?).to be true
    end


    context 'TJ_SCORES file does not exist' do
      it 'should create the TJ_SCORES file' do
        File.delete(@score_file_name) if File.exist?(@score_file_name)
        status = checker.check commit_file_name
        expect(File.exist?(@score_file_name)).to be true
      end
    end

    context 'score file does exist' do
      it 'should have a score for each commit message' do
        file = File.read(@score_file_name)
        scores = JSON.parse(file)
        expect(scores["Highly rated commit."]).to eq(3)
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
