module SpecUtils

  class Capture
    def self.stdout(&block)
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

  class MockResponse
    def self.committer_email
      "test@docondev.com"
    end

    def self.committer_name
      "Test User"
    end

    def self.commit_hash
      "Stubbed Commit Hash " + rand(10..1000).to_s
    end

    def self.commit_score
      3
    end

    def self.commit_message
      "Running Specs"
    end

    def self.body
      "More detailed content of the commit message

      Has returns and stuff."
    end

    def self.repo_location
      "git@github.com:DocOnDev/team_joy.git"
    end

    def self.https_location
      "https://github.com/DocOnDev/team_joy"
    end

    def self.branch_name
      "mock-branch"
    end

    def self.score
      3
    end

    def self.commit_hash
      "80b0f9e8f0062c2ccee0ad246a2a983230122cf6"
    end

    def self.raw_files
      "lib/git_commit.rb
lib/graph_query.rb
spec/git_commit_spec.rb
"
    end

    def self.files
      raw_files.split(/\n+|\r+/).reject(&:empty?)
    end
  end

  class Resource
    @resource_dir = File.join(File.dirname(__FILE__), '../resources/')
    def self.file(file_name)
      File.join(@resource_dir, file_name)
    end
  end
end
