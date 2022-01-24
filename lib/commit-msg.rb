#!/usr/bin/env ruby
require_relative 'git_commit_message_handler'

file_arg = ARGV[0]

if file_arg
  GitCommitMessageHandler.execute(file_arg)
end
