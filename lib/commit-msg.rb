#!/usr/bin/env ruby
require_relative 'commit_message_handler'

if file_arg
  CommitMessageHandler.execute(file_arg)
end
