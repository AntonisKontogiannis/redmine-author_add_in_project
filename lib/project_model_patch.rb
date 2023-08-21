require 'project'

module ProjectModelPatch
    def self.included(base)
        base.class_eval do
            belongs_to :author, :class_name => 'User'
            validates_presence_of :author_id
        end
    end
end

# This tells the Model to include the module
Project.send(:include, ProjectModelPatch)