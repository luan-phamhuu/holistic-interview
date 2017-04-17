require 'spec_helper'

RSpec.describe Ledis::Command do
  before(:each) do |example|
    stub_const('Ledis::Command::COMMANDS', [:command0, :command1, :some_command])
  end

  subject { described_class.new(:some_command) }

  describe "init" do
    it "should be initialized with 1 argument" do
      expect { described_class.new }.to raise_exception ArgumentError, /expected 1/
    end

    it "should raise error if the first argument is not symbol" do
      expect { described_class.new(double('Some class'), []) }.to raise_exception ArgumentError, /command must be symbol/
    end

    it "should raise error if the first argument is not an array" do
      expect { described_class.new(:a, double('not array')) }.to raise_exception ArgumentError, /params must be array/
    end

    describe "#available?" do
      it "should return true if COMMANDS list contain this command" do
        expect(described_class.new(:command0).available?).to eq true
      end

      it "should return false if COMMANDS list does not contain this command" do
        expect(described_class.new(:not_exist_command).available?).to eq false
      end
    end

    describe "#available!" do
      it "should call available?" do
        expect(subject).to receive(:available?).and_call_original
        subject.available!
      end

      it "should return what #available? return" do
        allow(subject).to receive(:available?).and_return('whatever')
        expect(subject.available!).to eq 'whatever'
      end

      it "should raise exception if available? return false" do
        subject = described_class.new(:some_command)
        allow(subject).to receive(:available?).and_return(false)
        expect { subject.available! }.to raise_exception Ledis::Errors::UnknownCommandError
      end
    end

    describe "#can_apply_to_key?" do
      before(:each) do |example|
        allow(Ledis).to receive(:type_table).and_return({ 'key0' => 0, 'key1' => 1, 'key2' => 2 })
        stub_const('Ledis::Command::COMMAND_TYPE_MAP', { :command0 => 0, :command1 => 1 })
      end

      context "when command and type of key is the same category" do
        it "should return true" do
          expect(described_class.new(:command0).can_apply_to_key? 'key0').to eq true
        end
      end

      context "when command and type of key is not the same category" do
        it "should return false" do
          expect(described_class.new(:command0).can_apply_to_key? 'key1').to eq false
        end
      end

      context "when key does not exsit" do
        it "should return true" do
          expect(described_class.new(:command0).can_apply_to_key? 'not_exist_key').to eq true
        end
      end
    end

    describe "#can_apply_to_key!" do
      before(:each) do |example|
        allow(Ledis).to receive(:type_table).and_return({ 'key0' => 0, 'key1' => 1, 'key2' => 2 })
        stub_const('Ledis::Command::COMMAND_TYPE_MAP', { :command0 => 0, :command1 => 1 })
      end

      it "should call #can_apply_to_key?" do
        expect(subject).to receive(:can_apply_to_key?).with('key0')
        subject.can_apply_to_key! 'key0'
      end

      it "should return what #can_apply_to_key? return" do
        allow(subject).to receive(:can_apply_to_key?).and_return('whatever')
        expect(subject.can_apply_to_key! 'whatever key').to eq 'whatever'
      end

      it "should raise exception if #can_apply_to_key? return false" do
        allow(subject).to receive(:can_apply_to_key?).and_return(false)
        expect { subject.can_apply_to_key! 'whatever key'}.to raise_exception Ledis::Errors::WrongTypeError
      end
    end

    describe "#execute!" do
      before(:each) do |example|
        class << Ledis
          def some_command(param1, param2)
          end
        end
      end

      after(:each) do
        class << Ledis; remove_method :some_command; end
      end

      subject { described_class.new(:some_command, ['param1', 'param2']) }
      it "should call #available!" do

        expect(subject).to receive(:available!)
        subject.execute!
      end

      it "should call send on Ledis with corrent arguments" do
        expect(Ledis).to receive(:send).with(:some_command, 'param1', 'param2')
        subject.execute!
      end
    end
  end
end
