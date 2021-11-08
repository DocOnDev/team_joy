results = `git log -1 HEAD --name-only --format=format:"{id:%H, short-id:%h, author:%an, committer:%cn subject:%s, body:%b}"`
puts "Raw Reults: " + results
parts = results.split("\n")
details = parts.shift
puts "Details: " + details
parts.each{ |part| puts "Part: " + part}
