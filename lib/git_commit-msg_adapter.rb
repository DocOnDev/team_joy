class GitCommitMessageAdapter

  def message_from_file commit_file_name
    raise ArgumentError.new("not a valid file") unless File.file?(commit_file_name)

    commit_message = CommitMessage.new

    content = load_content_from_file commit_file_name
    commit_message.subject = get_subject_from content
    commit_message.score = get_score_from content

    return commit_message
  end

private
  def load_content_from_file file_name
    File.readlines file_name
  end

  def get_score_from content
    get_subject_line_from(content).scan(/-(\d)-/).first[0].to_i
  end

  def get_subject_from content
    subject_line = get_subject_line_from(content)
    subject_line.slice!("-#{get_score_from(content)}- ")
    subject_line.strip()
  end

  def get_subject_line_from content
    String.new(content[0])
  end

end
