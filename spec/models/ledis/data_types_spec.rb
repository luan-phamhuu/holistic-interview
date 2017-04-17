require 'spec_helper'

RSpec.describe Ledis::DataTypes do
  let(:described_module) { Ledis::DataTypes }
  let(:dummy_class) {
    Class.new {
      @@type_table = {}

      def self.type_table
        @@type_table
      end

      include Ledis::DataTypes
    }
  }

  it "should raise exception if class dont have type_table method " do
    klass = Class.new
    expect { klass.include described_module }.to raise_exception RuntimeError, /must implement type_table method/
  end

  describe "::get_key_type" do
    before(:each) do |example|
      allow(dummy_class).to receive(:type_table).and_return({ 'key0' => 0, 'key1' => 1, 'key2' => 2 })
    end

    it "should return type of this key" do
      expect(dummy_class.get_key_type('key0')).to eq 0
      expect(dummy_class.get_key_type('key1')).to eq 1
      expect(dummy_class.get_key_type('key2')).to eq 2
    end
  end
end
