class LmsMailer < ApplicationMailer
  def applied_for_leave(leave, user, working_days, leave_days)
    @leave = leave
    @user = user
    @working_days = working_days
    @leave_days = leave_days
    @id=user.manager_id
    @manager=User.find(@id)
    @manager_email=@manager.email
    mail(:to => @manager_email, :subject => "Leave request for #{leave.total_days} days", :from => "notifications@gmail.com")
  end

  def leave_approved(leave,user, status)
    @leave = leave
    @user = user
    @status = status
    mail(:to => leave.user.email, :subject => "Leave request", :from => "notifications@gmail.com")
  end
end
