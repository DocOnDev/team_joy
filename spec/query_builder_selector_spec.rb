require 'rspec'
require './lib/query_builder_selector'

describe 'Query Builder Selector' do

  describe 'build' do
    context "Default (GraphCms)" do
      let(:query_builder){QueryBuilderSelector.select}

      it 'should return a GraphCmsQueryBuilder object' do
        expect(query_builder).to be_a(GraphCmsQueryBuilder)
      end
    end

    context "Config with explicit GraphCms" do
      let(:config_file) {SpecUtils::Resource.file("config_sample_valid.yml")}
      let(:config) {JoyConfig.new(config_file)}
      let(:query_builder){QueryBuilderSelector.with_config(config).select}

      it 'should return a GraphCmsQueryBuilder object' do
        expect(query_builder).to be_a(GraphCmsQueryBuilder)
      end
    end

    context "Config with explicit Oracle" do
      let(:config_file) {SpecUtils::Resource.file("config_sample_valid_oracle.yml")}
      let(:config) {JoyConfig.new(config_file)}
      let(:query_builder){QueryBuilderSelector.with_config(config).select}

      it 'should return a OracleQueryBuilder object' do
        expect(query_builder).to be_a(OracleQueryBuilder)
      end
    end
  end
end
