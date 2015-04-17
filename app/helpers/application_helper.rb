module ApplicationHelper
  def vue_component name, options = {}
    model_name = name.tableize.split('_').tap{ |names| names.delete('components')}.join('_')
    with = options.delete(:with)
    (@_vue_component_templates ||= []) << render("components/#{model_name}")
    content_tag :div, '', 'v-component' => name, 'v-with' => with
  end

  def render_vue_component_templates
    @_vue_component_templates.join('').html_safe
  end
end
