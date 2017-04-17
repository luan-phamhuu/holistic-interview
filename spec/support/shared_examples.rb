require "rails_helper"

shared_examples_for 'command does not require checking apply capability' do |a_proc|
  it "should not need to check command availability" do
    command = double(Ledis::Command)
    allow(Ledis::Command).to receive(:new).and_return(command)
    expect(command).not_to receive(:can_apply_to_key?)
    a_proc.call
  end
end

shared_examples_for 'command require checking apply capability' do |command, key, a_proc|
  it "should check for command availability" do
    command_instance = Ledis::Command.new(command)
    expect(Ledis::Command).to receive(:new).with(command).and_return(command_instance)
    expect(command_instance).to receive(:can_apply_to_key?).with(key)
    a_proc.call
  end
end
