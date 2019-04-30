require 'rspec'
require './commit-msg'

class CaptureOutput
  def self.capture_stdout(&block)
    original_stdout = $stdout
    $stdout = fake = StringIO.new
    begin
      yield
    ensure
      $stdout = original_stdout
    end
    fake.string
  end
end

describe 'Commit Message Handler' do

  it 'should tell me the file name' do
    checker = CheckCommit.new
    file_name = 'FileName.txt'
    output = CaptureOutput.capture_stdout { checker.check file_name }
    expect(output).to include "(#{file_name})"
  end


end

