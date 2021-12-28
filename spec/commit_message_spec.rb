require_relative 'spec_utils.rb'
require 'rspec'
require './lib/commit_message'

describe 'Commit Message' do
  let(:commitMessage){CommitMessage.new}

  context "Subject Property" do
    it 'should reject a non-String value' do
      expect do
        output = SpecUtils::Capture.stdout { commitMessage.subject = 42 }
        expect(output).to include "A commit subject must be a String"
      end.to raise_error(SystemExit)
    end

    it 'should accept a String value' do
      commitMessage.subject = "String Subject"
      expect(commitMessage.subject).to eq("String Subject")
    end
  end

  context "Score Property" do
    it 'should reject a non-Integer value' do
      expect do
        output = SpecUtils::Capture.stdout { commitMessage.score = "Big Score" }
        expect(output).to include "A commit score must be an Integer"
      end.to raise_error(SystemExit)
    end

    it 'should reject an Integer value less than 0' do
      expect do
        output = SpecUtils::Capture.stdout { commitMessage.score = -1 }
        expect(output).to include "A commit score must be an Integer between 0 and 5"
      end.to raise_error(SystemExit)
    end

    it 'should reject an Integer value greater than 5' do
      expect do
        output = SpecUtils::Capture.stdout { commitMessage.score = 6 }
        expect(output).to include "A commit score must be an Integer between 0 and 5"
      end.to raise_error(SystemExit)
    end

    it 'should accept an Integer value between 0 and 5' do
      commitMessage.score = 3
      expect(commitMessage.score).to eq(3)
    end
  end

  context "Body Property" do
    it 'should reject a non-String value' do
      expect do
        output = SpecUtils::Capture.stdout { commitMessage.body = [6] }
        expect(output).to include "A commit body must be a String"
      end.to raise_error(SystemExit)
    end

    it 'should accept a String value' do
      commitMessage.body = "This is the message body"
      expect(commitMessage.body).to eq("This is the message body")

    end
  end
end
