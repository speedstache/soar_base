module ApplicationHelper

  def profile_image_for(user, options = { size: 80 })
    size = options[:size]
    classes = "rounded shadow mx-auto d-block profile-image"

    if user.profile_image_attached?
      image_tag(user_profile_image_path(user), alt: "#{user.username}'s profile image", class: classes, width: size, height: size)
    else
      content_tag(:span, user.username.first.upcase, class: "#{classes} profile-image-placeholder", style: "width: #{size}px; height: #{size}px", role: "img", aria: { label: "No profile image for #{user.username}" })
    end
  end
  
end
