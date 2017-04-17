require 'spec_helper'
require 'support/shared_examples.rb'

RSpec.describe Ledis do
  it "should have a class variable named value_table" do
    expect { described_class.class_variable_get('@@value_table') }.not_to raise_exception
  end

  describe "value_table" do
    it "should be a hash" do
      expect(described_class.class_variable_get('@@value_table')).to be_instance_of Hash
    end

    it "can not be modified through class_variable_set" do
      expect{ described_class.class_variable_set('@@value_table', 'anything') }.to raise_exception ArgumentError, /value_table is not allowed to modify/
    end
  end

  it "should have a class variable named type_table" do
    expect { described_class.class_variable_get('@@type_table') }.not_to raise_exception
  end

  describe "type_table" do
    it "should be a hash" do
      expect(described_class.class_variable_get('@@type_table')).to be_instance_of Hash
    end

    it "can not be modified through class_variable_set" do
      expect{ described_class.class_variable_set('@@type_table', 'anything') }.to raise_exception ArgumentError, /type_table is not allowed to modify/
    end
  end

  def value_for_key(key)
    described_class.value_table[key]
  end

  def type_for_key(key)
    Ledis::DataTypes::DATATYPES_MAP.key(described_class.type_table[key])
  end

  before(:each) do |example|
    # TODO: flush before each example
  end

  describe "::set" do
    it_should_behave_like "command does not require checking apply capability", Proc.new { described_class.set('a', 'some string') }

    it "should store value in value_table" do
      described_class.set('a', 'some string')
      expect(value_for_key('a')).to eq 'some string'
    end

    it "should mark value that have type String" do
      described_class.set('a', 'some string')
      expect(type_for_key('a')).to eq 'String'
    end
  end

  describe "::get" do
    it_should_behave_like "command require checking apply capability", Proc.new { described_class.get('a') }

    it "should return value of that key" do
      allow(described_class).to receive(:value_table).and_return({'a' => 'some string', 'b' => 'another string'})
      expect(described_class.get('a')).to eq 'some string'
    end

  end

end
