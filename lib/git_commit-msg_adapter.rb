require 'commit_message'

class GitCommitMessageAdapter

  def self.message_from_file(commit_file_name)
    raise ArgumentError.new("not a valid file") unless File.file?(commit_file_name)

    commit_message = CommitMessage.new

    content = load_content_from_file commit_file_name
    commit_message.subject = get_subject_from content
    commit_message.score = get_score_from content
    commit_message.body = get_body_from content

    return commit_message
  end

private
  def self.load_content_from_file file_name
    File.readlines file_name
  end

  def self.get_score_from content
    scoreList = get_subject_line_from(content).scan(/-(\d)-/).first
    if scoreList
      return scoreList[0].to_i
    end
    return -1
  end

  def self.get_subject_from content
    subject_line = get_subject_line_from(content)
    subject_line.slice!("-#{get_score_from(content)}- ")
    subject_line.strip()
  end

  def self.get_body_from content
    content_without_subject = content.difference([get_subject_line_from(content)])
    content_without_subject.shift if content_without_subject[0] == "\n"
    content_without_subject.join()
  end

  def self.get_subject_line_from content
    String.new(content[0])
  end

end
