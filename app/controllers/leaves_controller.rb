class LeavesController < ApplicationController
  before_action :authenticate_user!
  before_action :manager_required, :only => [:leave_to_approve, :approve_leave]

  def leave_history
    @leaves = LeaveInfo.where("user_id =? AND end_date < ? ", current_user.id, Date.today )
  end

  def index
    @leaves = LeaveInfo.where("user_id =? AND end_date >= ? ", current_user.id, Date.today )
  end

  def new
    @leave_info = LeaveInfo.new
  end

  def create
    @leave_info = LeaveInfo.new(leaveinfo_params)
    start_date = @leave_info.string_to_date(params['start_date'])
    end_date = @leave_info.string_to_date(params['end_date'])
    @total_days = total_days_applied(start_date, end_date)
    @holiday_day = Holiday.new.holiday_between_leaves(start_date, end_date)
    @working_day = @total_days.reject{ |d| @holiday_day.include?(d)}
    @leave_info.user_id = current_user.id
    @leave_info.manager_id = current_user.manager_id
    @leave_info.status = "Pending"
    @leave_info.working_days = @working_day.count
    @leave_info.holiday_days = @holiday_day.count
    @leave_info.total_days = @total_days.size
    if @leave_info.valid?
      @leave_info.save
      LmsMailer.applied_for_leave(@leave_info, current_user, @working_day, @holiday_day).deliver
      redirect_to leaves_path
    else
      render 'new'
    end
  end

  def total_days_applied(start_date, end_date)
    LeaveInfo.new.leave_array(start_date, end_date)
  end

  def show
    @leave = LeaveInfo.find(params[:id])
  end

  def edit
    @leave_info = LeaveInfo.find(params[:id])
  end

  def update
    @leave_info = LeaveInfo.find(params[:id])
    if @leave_info.update(leaveinfo_params)
      redirect_to leaves_path
    else
      render "edit"
    end
  end

  def destroy
    @leave = LeaveInfo.find(params[:id])
    @leave.delete
    redirect_to leaves_path
  end

  def leave_to_approve
    @leaves = LeaveInfo.where(:manager_id => current_user.id, :status => "Pending")
  end

  def approve_leave
    leave = LeaveInfo.find(params[:id])
    status = params[:rejected].present? ? params[:rejected] : "Approved"
    if leave.update_attribute("status",status)
      LmsMailer.leave_approved(leave,current_user, status).deliver
      flash[:notice] = "Leave updated successfully"
      redirect_to leave_to_approve_leaves_path
    end
  end

  def manager_required
    if current_user && current_user.is_manager?
      true
    else
      flash[:notice] = "You are not authorized to Approve Leaves"
      redirect_to new_user_session_path
    end
  end

  private
   def leaveinfo_params
     params.permit(:start_date, :end_date, :reason_for_leave)
   end
end
