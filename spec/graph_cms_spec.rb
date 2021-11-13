require_relative 'spec_utils.rb'
require 'rspec'
require './lib/graph_cms'

describe 'GraphCMS' do
  context 'Without Commit Object' do
    it 'should raise an error' do
      graph_cms = GraphCMS.new()
      expect {graph_cms.query}.to raise_error(/GitCommit/)
    end
  end

end
