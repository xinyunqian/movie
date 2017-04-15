class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy, :join, :quit]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 8)
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user

    if @group.save
      current_user.join!(@group)
      redirect_to groups_path
    else
      render :new
    end
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to groups_path, notice: '更新成功'
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])

    if current_user != @group.user
      redirect_to root_path, alert: "对不起，您没有权限。"
    end

    @group.destroy
    redirect_to groups_path, alert: '该影片已删除'
  end

  def join
   @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "标记看过本片成功"
    else
      flash[:warning] = "你已标记看过本片了"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "取消标记看过本片成功！"
    else
      flash[:warning] = "您还没有标记看过本片哦，无法取消标记 XD"
    end

    redirect_to group_path(@group)
  end

  private



  def group_params
    params.require(:group).permit(:电影名称, :电影类型, :上映年份)
  end
end
