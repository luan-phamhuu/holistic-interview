class ConsoleController < ApplicationController
  def index
  end

  def web_console
    asfs
  end

  def handle_command
    render json: {"output" => "=\u003e nil"}
  end
end
