class ConsoleController < ApplicationController
  def index
  end

  def web_console
    asfs
  end

  def handle_command
    old_key = $ledis_table["key"]
    $ledis_table["key"] = old_key + 1

    render json: {"output" => "#{$ledis_table["key"]}"}


    # render json: {"output" => "#{$redis.incr :a}"}
  end
end
