class GitCommitMessageAdapter

  def message_from_file commit_file_name
    raise ArgumentError.new("not a valid file") unless File.file?(commit_file_name)
    content = load_content_from_file commit_file_name
    commitMessage = CommitMessage.new
    commitMessage.score = get_score_from content
    commitMessage
  end

private
  def load_content_from_file file_name
    File.readlines file_name
  end

  def get_score_from content
    get_subject_line_from(content).scan(/-(\d)-/).first[0].to_i
  end

  def get_subject_line_from content
    content[0]
  end

end
