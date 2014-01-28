class CommunityProfilesController < ApplicationController
  layout "community"
  before_filter :grab_community
  before_filter :grab_user
  before_filter :grab_member, except: [:join, :create, :show]
  before_filter :authenticate_user!, except: [:show, :detail, :invite]
  skip_before_filter :require_login, only: [:show, :detail, :invite]

  def show
    @member = @community.community_profiles.find_by_param(params[:community_id],params[:id])
  end

  def invite
    @community_concerns = @community.concern_list

    all_relevant_users = User.tagged_with(@community_concerns, :any => true) - @community.members.map(&:user)

    viewer_location = current_user.current_location.location.address
    nearby_locations = Location.near(viewer_location, 50)
    check_ins = UserLocation.where(current: true, location_id: nearby_locations.map(&:id))

    @users = all_relevant_users & (check_ins.map(&:user) - @community.members.map(&:user))
  end

  def join
    @member = @community.community_profiles.build
  end

  def create
    unless @community.has_as_member?(@user)
      @member = @community.community_profiles.build(params[:community_profile])
      @member.user = @user
      @member.admin = true if @user.is?("admin")

      if @member.save!
        @user.interest_list << @community.name
        @user.save!
        flash[:notice] = "You've claimed your spot! Welcome to #{@community.name}!\n The #{@community.name} community has been added to your profile."
        redirect_to community_path(@community)
      else
        flash.now[:alert] = "Try again!"
        render :join
      end
    else
      flash[:notice] = "You're already a member!"
      redirect_to community_path(@community)
    end
  end

  def edit
  end

  def update
    if @member.update_attributes(params[:community_profile])
      flash[:notice] = "Your #{@community.name} profile has been updated."
      redirect_to community_path(@community)
    else
      flash[:alert] = "Update failure!"
      render :edit
    end
  end

  def destroy
    @member = @community.find_member(@user)
    @member.destroy
    redirect_to community_path(@community)
  end

  private

  def grab_user
    @user = current_user
  end

  def grab_community
    @community = Community.find_by_param(params[:community_id])
  end

  def grab_member
    @member = @community.find_member(@user)
  end

end
