require_relative 'spec_utils.rb'
require 'rspec'
require './lib/joy_config'

describe 'Code Joy Configuration' do

  context 'given a missing config file' do
    let(:missing_config_file) {'./not_a_file.yml'}

    it 'should fail a missing config file' do
      expect {JoyConfig.new(missing_config_file)}.to raise_error(ArgumentError, /Invalid Configuration File Path/)
    end
  end

  context 'given no config file' do
    it 'should default to joy_config.yml in the same directory'do
      config = JoyConfig.new()
      expect(config.is_loaded_from_default?).to be true
    end
  end

  context 'given a valid configuration file' do
    let(:config_file) {SpecUtils::Resource.file("config_sample_valid.yml")}

    before(:each) do
      @config = JoyConfig.new(config_file)
    end

    it 'should not be loaded from default' do
      expect(@config.is_loaded_from_default?).to be false
    end

    it 'should have a score file path' do
      expect(@config.score_file_name).to include("./score_file")
    end

    it 'should have a CMS URI' do
      expect(@config.cms_uri).to eq("https://some.graphcms.com/version/key/branch")
    end

    it 'should have a CMS Token' do
      expect(@config.cms_token).to eq("SomeToken")
    end

    it 'should be a public CMS endpoint' do
      expect(@config.is_cms_public?).to be true
    end
  end

  context 'given a configuration with no score entry' do
    let(:config_file) {SpecUtils::Resource.file("config_sample_no_score.yml")}

    before(:each) do
      @config = JoyConfig.new(config_file)
    end

    it 'should default the score file to ./TJ_SCORES' do
      expect(@config.score_file_name).to include("./TJ_SCORES")
    end
  end

  context 'given a configuration with no score path' do
    let(:config_file) {SpecUtils::Resource.file("config_sample_no_score_path.yml")}

    before(:each) do
      @config = JoyConfig.new(config_file)
    end

    it 'should default the score file to ./TJ_SCORES' do
      expect(@config.score_file_name).to include("./TJ_SCORES")
    end
  end

  context 'given a configuration with an empty score path' do
    let(:config_file) {SpecUtils::Resource.file("config_sample_empty_score_path.yml")}

    before(:each) do
      @config = JoyConfig.new(config_file)
    end

    it 'should default the score file to ./TJ_SCORES' do
      expect(@config.score_file_name).to include("./TJ_SCORES")
    end
  end

end
