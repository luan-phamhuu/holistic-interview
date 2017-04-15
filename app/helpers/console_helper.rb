module ConsoleHelper
  # Render JavaScript inside a script tag and a closure.
  #
  # This one lets write JavaScript that will automatically get wrapped in a
  # script tag and enclosed in a closure, so you don't have to worry for
  # leaking globals, unless you explicitly want to.
  def render_javascript(template)
    assign(template: template)
    render(template: template, layout: 'layouts/javascript')
  end

  # Render inlined string to be used inside of JavaScript code.
  #
  # The inlined string is returned as an actual JavaScript string. You
  # don't need to wrap the result yourself.
  def render_inlined_string(template)
    render(template: template, layout: 'layouts/inlined_string')
  end
end
