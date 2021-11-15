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
  end

  class Resource
    @resource_dir = File.join(File.dirname(__FILE__), '../resources/')
    def self.file(file_name)
      File.join(@resource_dir, file_name)
    end
  end
end
