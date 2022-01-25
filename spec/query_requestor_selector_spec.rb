require 'rspec'
require './lib/query_requestor_selector'

describe 'Query Requestor Selector' do

  describe 'select' do
    context "Default (GraphCms)" do
      let(:query_requestor){QueryRequestorSelector.select}

      it 'should return a GraphCmsQueryRequestor object' do
        expect(query_requestor).to be_a(GraphCmsQueryRequestor)
      end
    end

    context "Config with explicit GraphCms" do
      let(:config_file) {SpecUtils::Resource.file("config_sample_valid.yml")}
      let(:config) {JoyConfig.new(config_file)}
      let(:query_requestor){QueryRequestorSelector.with_config(config).select}

      it 'should return a GraphCmsQueryRequestor object' do
        expect(query_requestor).to be_a(GraphCmsQueryRequestor)
      end
    end

    context "Config with explicit Oracle" do
      let(:config_file) {SpecUtils::Resource.file("config_sample_valid_oracle.yml")}
      let(:config) {JoyConfig.new(config_file)}
      let(:query_requestor){QueryRequestorSelector.with_config(config).select}

      it 'should return a OracleQueryRequestor object' do
        expect(query_requestor).to be_a(OracleQueryRequestor)
      end
    end
  end
end
