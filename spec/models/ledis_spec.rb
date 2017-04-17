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

    # it "can not be modified through class_variable_set" do
    #   expect{ described_class.class_variable_set('@@value_table', 'anything') }.to raise_exception ArgumentError, /value_table is not allowed to modify/
    # end
  end

  it "should have a class variable named type_table" do
    expect { described_class.class_variable_get('@@type_table') }.not_to raise_exception
  end

  describe "type_table" do
    it "should be a hash" do
      expect(described_class.class_variable_get('@@type_table')).to be_instance_of Hash
    end

    # it "can not be modified through class_variable_set" do
    #   expect{ described_class.class_variable_set('@@type_table', 'anything') }.to raise_exception ArgumentError, /type_table is not allowed to modify/
    # end
  end

  def value_for_key(key)
    described_class.value_table[key]
  end

  def type_for_key(key)
    Ledis::DataTypes::DATATYPES_MAP.key(described_class.type_table[key])
  end

  # Restore database before each test
  before(:each) do |example|
    described_class.class_variable_set('@@value_table', {})
    described_class.class_variable_set('@@type_table', {})
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
    it_should_behave_like "command require checking apply capability", :get, 'a', Proc.new { described_class.get('a') }

    it "should return value of that key" do
      allow(described_class).to receive(:value_table).and_return({'a' => 'some string', 'b' => 'another string'})
      allow(described_class).to receive(:type_table).and_return({'a' => 0, 'b' => 0})
      expect(described_class.get('a')).to eq 'some string'
    end
  end

  describe "::llen" do
    before(:each) do |example|
      allow(described_class).to receive(:value_table).and_return({'a' => ['1', '2', '3']})
      allow(described_class).to receive(:type_table).and_return({'a' => 1})
    end

    it_should_behave_like "command require checking apply capability", :llen, 'a', Proc.new { described_class.llen('a') }

    it "should return length of the array stored" do
      expect(described_class.llen('a')).to eq 3
    end
  end

  describe "::rpush" do
    it_should_behave_like "command require checking apply capability", :rpush, 'a', Proc.new { described_class.rpush('a', 1, 2) }

    context "when key is not exist" do
      before(:each) do |example|
        allow(described_class).to receive(:value_table).and_return({})
        allow(described_class).to receive(:type_table).and_return({})
      end

      it "should create a new list at this key" do
        described_class.rpush('a', 1, 2)
        expect(value_for_key('a')).to eq [1, 2]
      end
    end

    context "when key is already exist" do
      before(:each) do |example|
        allow(described_class).to receive(:value_table).and_return({'a' => ['1']})
        allow(described_class).to receive(:type_table).and_return({'a' => 1})
      end

      it "should push all values to end of list" do
        described_class.rpush('a', '2', '3')
        expect(value_for_key('a')).to eq ['1', '2', '3']
      end
    end

    it "should mark value that have type List" do
      described_class.rpush('a', '1')
      expect(type_for_key('a')).to eq 'List'
    end

    it "should return length of list" do
      expect(described_class.rpush('a', 1, 2)).to eq 2
      expect(described_class.rpush('a', 3, 100)).to eq 4
    end
  end

  describe "::lpop " do
    it_should_behave_like "command require checking apply capability", :lpop, 'a', Proc.new { described_class.lpop('a') }

    context "when key does not exist" do
      before(:each) do |example|
        described_class.class_variable_set('@@value_table', {})
        described_class.class_variable_set('@@type_table', {})
      end

      it "should return nil" do
        expect(described_class.lpop('a')).to be_nil
      end
    end

    context "when key exist" do
      before(:each) do |example|
        described_class.class_variable_set('@@value_table', { 'a' => [1, 2, 3] })
        described_class.class_variable_set('@@type_table', { 'a' => 1 })
      end

      it "should remove first element of this list" do
        described_class.lpop('a')
        expect(value_for_key('a')).to eq [2, 3]
      end

      it "should return first element of list" do
        expect(described_class.lpop('a')).to eq 1
      end
    end
  end

  describe "::rpop " do
    it_should_behave_like "command require checking apply capability", :rpop, 'a', Proc.new { described_class.rpop('a') }

    context "when key does not exist" do
      before(:each) do |example|
        described_class.class_variable_set('@@value_table', {})
        described_class.class_variable_set('@@type_table', {})
      end

      it "should return nil" do
        expect(described_class.rpop('a')).to be_nil
      end
    end

    context "when key exist" do
      before(:each) do |example|
        described_class.class_variable_set('@@value_table', { 'a' => [1, 2, 3] })
        described_class.class_variable_set('@@type_table', { 'a' => 1 })
      end

      it "should remove first element of this list" do
        described_class.rpop('a')
        expect(value_for_key('a')).to eq [1, 2]
      end

      it "should return first element of list" do
        expect(described_class.rpop('a')).to eq 3
      end
    end
  end

  describe "::lrange" do
    it_should_behave_like "command require checking apply capability", :lrange, 'a', Proc.new { described_class.lrange('a', 1, 100) }



    context "when key is not exist" do
      before(:each) do |example|
        described_class.class_variable_set('@@value_table', {})
        described_class.class_variable_set('@@type_table', {})
      end

      it "should return empty array" do
        expect(described_class.lrange('a', 0, 100)).to eq []
      end
    end

    context "when key is exist" do
      before(:each) do |example|
        described_class.class_variable_set('@@value_table', { 'a' => [1, 2, 3, 4] })
        described_class.class_variable_set('@@type_table', { 'a' => 1 })
      end

      it "should return elements withing range" do
        expect(described_class.lrange('a', 0, 100)).to eq [1, 2, 3, 4]
        expect(described_class.lrange('a', 0, 3)).to eq [1, 2, 3, 4]
        expect(described_class.lrange('a', 0, 2)).to eq [1, 2, 3]
        expect(described_class.lrange('a', 1, 2)).to eq [2, 3]
        expect(described_class.lrange('a', 2, 2)).to eq [3]
        expect(described_class.lrange('a', 3, 2)).to eq []
      end
    end

    context "when key is exist but empty" do
      before(:each) do |example|
        described_class.class_variable_set('@@value_table', { 'a' => [] })
        described_class.class_variable_set('@@type_table', { 'a' => 1 })
      end

      it "should return empty array" do
        expect(described_class.lrange('a', 0, 100)).to eq []

      end
    end
  end

  # describe "::flushdb" do
  #   it_should_behave_like "command does not require checking apply capability", Proc.new { described_class.flushdb }
  #
  #
  #
  # end
end
