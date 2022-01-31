require_relative 'code_helpers'

class GitCommitMessageWriter < CodeHelpers::FieldValidations
  type_accessor CommitMessage, :message
  initialize_with :message

  def write_to_file(file_name)
    File.write(file_name, @message.subject + "\n\n" + @message.body)
  end
end
