class ServicesController < ProjectResourceController
  # Authorize
  before_filter :authorize_admin_project!

  respond_to :html

  def index
    @gitlab_ci_service = @project.gitlab_ci_service
    @hipchat_service = @project.hipchat_service
  end

  def edit
    @gitlab_ci_service = @project.gitlab_ci_service
    @hipchat_service =  @project.hipchat_service

    # Create if missing
    @gitlab_ci_service = @project.create_gitlab_ci_service unless @gitlab_ci_service
    @hipchat_service = @project.create_hipchat_service unless @hipchat_service
  end

  def update
    @gitlab_ci_service = @project.gitlab_ci_service
    @hipchat_service = @project.hipchat_service

    if @gitlab_ci_service.update_attributes(params[:service])
      redirect_to edit_project_service_path(@project, :gitlab_ci)
    elsif @hipchat_service.update_attributes(params[:service])
      redirect_to edit_project_service_path(@project, :hipchat)
    else
      render 'edit'
    end
  end

  def test
    data = GitPushService.new.sample_data(project, current_user)

    @gitlab_ci_service = project.gitlab_ci_service
    @gitlab_ci_service.execute(data)

    @hipchat_service = project.hipchat_service
    @hipchat_service.execute(data)

    redirect_to :back
  end
end
