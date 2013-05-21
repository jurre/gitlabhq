class ServicesController < ProjectResourceController
  # Authorize
  before_filter :authorize_admin_project!

  respond_to :html

  def index
    @gitlab_ci_service = @project.gitlab_ci_service
    @hip_chat_service = @project.hip_chat_service
  end

  def edit
    @gitlab_ci_service = @project.gitlab_ci_service
    @hip_chat_service =  @project.hip_chat_service

    # Create if missing
    @gitlab_ci_service = @project.create_gitlab_ci_service unless @gitlab_ci_service
    @hip_chat_service = @project.create_hip_chat_service unless @hip_chat_service
  end

  def update
    @gitlab_ci_service = @project.gitlab_ci_service
    @hip_chat_service = @project.hip_chat_service

    if @gitlab_ci_service.update_attributes(params[:service])
      redirect_to edit_project_service_path(@project, :gitlab_ci)
    elsif @hip_chat_service.update_attributes(params[:service])
      redirect_to edit_project_service_path(@project, :hip_chat)
    else
      render 'edit'
    end
  end

  def test
    data = GitPushService.new.sample_data(project, current_user)

    @gitlab_ci_service = project.gitlab_ci_service
    @gitlab_ci_service.execute(data)

    @hip_chat_service = project.hip_chat_service
    @hip_chat_service.execute(data)

    redirect_to :back
  end
end
