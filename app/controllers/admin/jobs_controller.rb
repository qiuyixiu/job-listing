class Admin::JobsController < ApplicationController
  before_action :authenticate_user!, only:[:new, :create, :update, :edit, :destroy, :index]
  before_action :require_is_admin
  def index
    @jobs = Job.all
  end

  def new
    @job = Job.new
  end

  def show
    @job = Job.find(params[:id])
  end

  def edit
    @job = Job.find(params[:id])
  end

  def create
    @job = Job.find(job_params)
    if @job.save
      redirect_to admin_jobs_path
    else
      render :new
    end
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params[:id])
      redirect_to admin_jobs_path, notice: "Update Success"
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to admin_jobs_path, alert: "Job deleted"
  end

  

  private

  def job_params
    params.require(:job).permit(:title, :description)
  end

end
