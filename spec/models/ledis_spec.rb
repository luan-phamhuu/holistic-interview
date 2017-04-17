require 'spec_helper'

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

  

end
