require_relative 'spec_utils.rb'
require 'rspec'
require './lib/code_helpers'

class DataTypesTest < CodeHelpers::DataTypes
  string_accessor :string_field, :string_field_two
  int_accessor :int_field
  type_accessor Array, :array_field
end

describe 'CodeHelpers' do
  let(:under_test){DataTypesTest.new}

  describe "type_accessor" do
    it 'should reject a value not of the designated type' do
      expect { under_test.array_field = 41 }.to raise_error(ArgumentError, /must be of type Array/)
    end

    it 'should accept a value of the designated type' do
      under_test.array_field = ["String Value"]
      expect(under_test.array_field).to eq(["String Value"])
    end
  end

  describe "string_accessor" do
    it 'should reject a non-String value' do
      expect { under_test.string_field_two = 41 }.to raise_error(ArgumentError, /must be of type String/)
    end

    it 'should accept a String value' do
      under_test.string_field = "String Value"
      expect(under_test.string_field).to eq("String Value")
    end
  end

  describe "int_accessor" do
    it 'should reject a non-Integer value' do
      expect { under_test.int_field = [41] }.to raise_error(ArgumentError, /must be of type Integer/)
    end

    it 'should accept an Integer value' do
      under_test.int_field = 99
      expect(under_test.int_field).to eq(99)
    end
  end
end
