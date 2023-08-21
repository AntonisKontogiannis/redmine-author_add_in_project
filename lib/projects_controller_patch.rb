require 'projects_controller'

module ProjectsControllerPatch
    def self.included(base)
        base.class_eval do
            unloadable
            prepend NewMethod
        end
    end
    module NewMethod
        def new
            @issue_custom_fields = IssueCustomField.sorted.to_a
            @trackers = Tracker.sorted.to_a
            @project = Project.new
            @project.safe_attributes = params[:project]
            @authors = User.active.where(admin: true).collect{|u| [u.name, u.id]}
        end

        def settings
            @issue_custom_fields = IssueCustomField.sorted.to_a
            @issue_category ||= IssueCategory.new
            @member ||= @project.members.new
            @trackers = Tracker.sorted.to_a
        
            @version_status = params[:version_status] || 'open'
            @version_name = params[:version_name]
            @versions = @project.shared_versions.status(@version_status).like(@version_name).sorted
            @authors = User.active.where(admin: true).collect{|u| [u.name, u.id]}
        end

        def create
            @issue_custom_fields = IssueCustomField.sorted.to_a
            @trackers = Tracker.sorted.to_a
            @project = Project.new
            @project.safe_attributes = params[:project]
        
            if @project.save
              unless User.current.admin?
                @project.add_default_member(User.current)
              end
              respond_to do |format|
                format.html do
                  flash[:notice] = l(:notice_successful_create)
                  if params[:continue]
                    attrs = {:parent_id => @project.parent_id}.reject {|k,v| v.nil?}
                    redirect_to new_project_path(attrs)
                  else
                    redirect_to settings_project_path(@project)
                  end
                end
                format.api do
                  render(
                    :action => 'show',
                    :status => :created,
                    :location => url_for(:controller => 'projects',
                                         :action => 'show', :id => @project.id)
                  )
                end
              end
            else
                redirect_to new_project_path
            end
        end
    end
end

# This tells the Controller to include the module
ProjectsController.send(:include, ProjectsControllerPatch)
