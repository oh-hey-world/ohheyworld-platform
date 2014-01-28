module UserFriendsHelper
  def active_item(param, name, display_name, path, user_friends)
    css_class = (param == name) ? "tab-active" : "tab"
    content_tag(:li, class: 'nav-mobile__sub-item') do
      link_to(dashboard_user_friends_path + path) do
      	content_tag(:div, class: "m2-m7 t2-t4 d1-d2") do
      		content_tag(:span, '', {class: '', 'aria-hidden' => 'true', 'data-icon'=>raw("&#xe00e;")}) +
      		content_tag(:span, display_name)
      	end
    	end
    end
  end

  def user_friend_relationship(user, friend_relationship)
    (friend_relationship) ? friend_relationship : current_user.user_friends.build(friend_id: user.id)
  end

  def tag_class(is_following, friend_relationship, tag_name)
    class_text = (is_following && friend_relationship.tag_list.include?(tag_name)) ? "js-unfollow-tag" : "js-follow-tag"
    class_text << ' js-add-to-profile-tag'
  end
end