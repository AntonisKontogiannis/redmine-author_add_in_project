require_relative "lib/projects_controller_patch"
require_relative "lib/project_model_patch"

Redmine::Plugin.register :author_add_in_project do
  name 'Author Add In Project plugin'
  author 'Antonios Kontogiannis'
  description 'This is a plugin for Redmine for adding author in project.'
  version '0.0.1'
  author_url 'https://www.linkedin.com/in/antonios-kontogiannis-5175751b2/'
  
  Project.safe_attributes 'author_id'
end

