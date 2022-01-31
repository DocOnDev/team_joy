require_relative 'spec_utils.rb'
require 'rspec'
require './lib/code_helpers'

class DataTypesTest < CodeHelpers::DataTypes
  string_accessor :string_field, :string_field_two
  int_accessor :int_field, :int_field_two
  int_range_accessor 0,5, :int_range, :int_range_two
  type_accessor Array, :array_field, :array_field_two
  email_accessor :email_field, :email_field_two
end

describe 'CodeHelpers' do
  let(:under_test){DataTypesTest.new}

  describe "type_accessor" do
    it 'should reject a value not of the designated type' do
      expect { under_test.array_field = 41 }.to raise_error(ArgumentError, /must be of type Array/)
    end

    it 'should accept a value of the designated type' do
      under_test.array_field_two = ["Array Value", "Stuff"]
      expect(under_test.array_field_two).to eq(["Array Value", "Stuff"])
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

  describe "email_accessor" do
    it 'should reject a non-email value' do
      expect { under_test.email_field_two = "41" }.to raise_error(ArgumentError, /must be a valid email/)
    end

    it 'should accept a String value' do
      under_test.email_field = "me@domain.com"
      expect(under_test.email_field).to eq("me@domain.com")
    end
  end

  describe "int_accessor" do
    it 'should reject a non-Integer value' do
      expect { under_test.int_field = [41] }.to raise_error(ArgumentError, /must be of type Integer/)
    end

    it 'should accept an Integer value' do
      under_test.int_field_two = 99
      expect(under_test.int_field_two).to eq(99)
    end
  end

  describe "int_range_accessor" do
    it 'should reject a value outside the range' do
      expect { under_test.int_range = 12 }.to raise_error(ArgumentError, /must be within the range/)
    end

    it 'should accept an Integer value within the range' do
      under_test.int_range_two = 4
      expect(under_test.int_range_two).to eq(4)
    end
  end

end
