require 'spec_helper'

RSpec.describe Ledis::CommandParser do
  describe "init" do
    it "should be initialized with 1 argument" do
      expect { described_class.new }.to raise_exception ArgumentError, /expected 1/
    end

    it "should raise error if argument is not String" do
      expect { described_class.new(double('Some class')) }.to raise_exception ArgumentError, /must be string/
    end

    it "should raise error if argument is empty" do
      expect { described_class.new('') }.to raise_exception ArgumentError, /can not be empty/
    end
  end

  describe "#parse" do
    describe "return value" do
      it "should be an array" do
        expect(described_class.new('a').parse).to be_instance_of Array
      end

      it "first element should be the command" do
        command, params = described_class.new('a').parse
        expect(command).to eq :a
      end

      it "should be able to parse the command no matter cases" do
        command, params = described_class.new('A').parse
        expect(command).to eq :a

        command, params = described_class.new('Ab').parse
        expect(command).to eq :ab

        command, params = described_class.new('aB').parse
        expect(command).to eq :ab

        command, params = described_class.new('AB').parse
        expect(command).to eq :ab
      end

      context "when command string have only 1 component" do
        it "params should be an empty array" do
          command, params = described_class.new('command').parse
          expect(params).to eq []
        end
      end

      context "when command string have 2 components" do
        it "params should contain the second component" do
          command, params = described_class.new('command param1').parse
          expect(params).to eq ['param1']
        end
      end

      context "when command string have more than 2 components" do
        it "params should contain components from the second to the last" do
          n = 10
          command_string = 'command'
          1.upto(n) do |i|
            command_string += " param#{i}"
          end

          subject = described_class.new(command_string)
          command, params = subject.parse
          expected_params = 1.upto(n).map { |i| "param#{i}" }
          expect(params).to match_array expected_params
        end
      end
    end
  end
end
