require_relative 'spec_utils.rb'
require 'rspec'
require './lib/code_helpers'

class DataTypesTest < CodeHelpers::DataTypes
  string_accessor :string_field
  int_accessor :int_field
end

describe 'CodeHelpers' do
  let(:under_test){DataTypesTest.new}

  describe "string_accessor" do
    it 'should reject a non-String value' do
      expect { under_test.string_field = 41 }.to raise_error(ArgumentError, /must be a string/)
    end

    it 'should accept a String value' do
      under_test.string_field = "String Value"
      expect(under_test.string_field).to eq("String Value")
    end
  end

  describe "int_accessor" do
    it 'should reject a non-Integer value' do
      expect { under_test.int_field = [41] }.to raise_error(ArgumentError, /must be an integer/)
    end

    it 'should accept an Integer value' do
      under_test.int_field = 99
      expect(under_test.int_field).to eq(99)
    end
  end
end
