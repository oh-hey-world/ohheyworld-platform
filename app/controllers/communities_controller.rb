class CommunitiesController < ApplicationController
  layout "community"
  before_filter :authenticate_user!, except: [:show, :detail]
  before_filter :grab_community
  before_filter :grab_user, except: [:show]
  before_filter :grab_member, except: [:show]
  skip_before_filter :require_login, only: [:show, :detail]

  def show
    if user_signed_in?
      @user = current_user
      viewer_location = @user.current_location.location.address
      nearby_locations = Location.near(viewer_location, 50)
      check_ins = UserLocation.where(current: true, location_id: nearby_locations.map(&:id), user_id: @community.members.map(&:user_id))

      @members_nearby = check_ins.map { |x| x.user.community_profiles.find_by_community_id(@community.id) }
      @members = @community.members - @members_nearby

      if @community.has_as_member?(@user)
        grab_member
        @members_nearby = @members_nearby - [@member]
        @members_nearby.unshift(@member)
      end
    else
      @members = @community.members
    end
  end

  def detail
  end

  def edit
    # Only admins can edit. Doing this in ability.rb didn't work for some reason
    if current_user.roles.include?("admin")
    else
      redirect_to root_path
      flash[:alert] = "Only admins can update communities"
    end
    # End only admins can edit
  end

  def update
    if @community.update_attributes(params[:community])
      flash[:notice] = "The #{@community.name} profile has been updated."
      redirect_to community_path(@community)
    else
      flash[:alert] = "Update failure!"
      render :edit
    end
  end

  private

  def grab_user
    @user = current_user
  end

  def grab_community
    @community = Community.find_by_param(params[:id])
  end

  def grab_member
    @member = @community.find_member(@user)
  end
end
