class CommitMessageWriter
  def initialize(message)
    @message = message
  end

  def write_to_file(file_name)
    File.write(file_name, @message.subject + "\n" + @message.body)
  end
end
