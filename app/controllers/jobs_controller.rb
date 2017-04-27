class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:quit]
  before_action :validate_search_key, only: [:search]



  def index
  # 按职位分类
     if params[:category].present?
       @category = params[:category]
       if @category == '所有职位'
         @jobs = Job.published.recent.paginate(:page => params[:page], :per_page => 5)
       else
         @jobs = Job.published.where(:category => @category).recent.paginate(:page => params[:page], :per_page => 5)
       end

     # 不分类
     else
       @jobs = case params[:order]
               when 'by_lower_bound'
                 Job.published.order('wage_lower_bound DESC').paginate(:page => params[:page], :per_page => 5)
               when 'by_upper_bound'
                 Job.published.order('wage_upper_bound DESC').paginate(:page => params[:page], :per_page => 5)
               else
                 Job.published.recent.paginate(:page => params[:page], :per_page => 5)
               end
     end

   end


  def new
    @job = Job.new
  end

  def show
    @job = Job.find(params[:id])

    if @job.is_hidden
      flash[:warning] = "This Job already archieved"
      redirect_to root_path
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to jobs_path
    else
      render :new
    end
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      redirect_to jobs_path, notice: "Update Success!"
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to jobs_path, alert: "Job deleted!"
  end

  def search
    if @query_string.present?
      search_result = Job.ransack(@search_criteria).result(:distinct => true)
      @jobs = search_result.paginate(:page => params[:page], :per_page => 5 )
    end
  end




  protected

  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "")
    if params[:q].present?
      @search_criteria =  { title_or_city_cont: @query_string }
    end
  end


  def search_criteria(query_string)
    { :title_cont => query_string }
  end



  private

  def job_params
    params.require(:job).permit(:title, :description, :wage_upper_bound, :wage_lower_bound, :contact_email, :is_hidden, :city, :category)
  end

end
