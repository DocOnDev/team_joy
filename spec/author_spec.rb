require_relative 'spec_utils.rb'
require 'rspec'
require './lib/author'

describe 'Author' do
    describe '#validations' do        
        let(:email_format){ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }

        context 'when proper data provided' do
            subject { Author.new("Name", "example@email.com") }

            it 'should validate that email is a String' do
                expect(subject.email).to be_a(String)
            end
    
            it 'should validate that name is a String' do
                expect(subject.name).to be_a(String)
            end
    
            it 'should validate that email has proper format' do
                expect(subject.email).to match(email_format)
            end
        end

        context 'when wrong data provided' do

            it 'should not create an Author when no email provided' do
                expect{ Author.new(32, "") }.to raise_error StandardError
            end

            it 'should not create an Author when wrong email format provided' do
                expect{ Author.new(32, "invalid_email") }.to raise_error StandardError
            end
        end
    end
end