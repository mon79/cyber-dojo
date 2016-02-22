
module TrafficLightHelper # mix-in

  module_function

  # The data-id, data-avatar-name, data-was-tag, data-now-tag
  # properties are used to create click handlers that open a diff-dialog
  #   see setupTrafficLightOpensHistoryDialogHandlers()
  #   in app/asserts/javascripts/cyber-dojo_traffic_lights.js
  # The data-tip property is used to create a hover-tip.
  #   see setupHoverTips()
  #   in app/asserts/javascripts/cyber-dojo_hover_tips.js

  def simple_diff_traffic_light(light)
    # used from test page and from dashboard page
    number = light.number
    colour = light.colour
    "<div class='diff-traffic-light'" +
        " data-tip='simple_review_traffic_light'" +
        " data-colour='#{colour}'" +
        " data-was-tag='#{number - 1}'" +
        " data-now-tag='#{number}'>" +
        traffic_light_image(light.colour) +
     '</div>'
  end

  def diff_traffic_light(light)
    # used from test page and from dashboard page
    avatar = light.avatar
    number = light.number
    colour = light.colour
    "<div class='diff-traffic-light'" +
        " data-tip='ajax:traffic_light'" +
        " data-id='#{avatar.kata.id}'" +
        " data-avatar-name='#{avatar.name}'" +
        " data-colour='#{colour}'" +
        " data-was-tag='#{number - 1}'" +
        " data-now-tag='#{number}'>" +
        traffic_light_image(light.colour) +
     '</div>'
  end

  def diff_avatar_image(avatar)
    "<div class='diff-traffic-light avatar-image'" +
        " data-tip='Click to review #{avatar.name}#{apostrophe}s current code'" +
        " data-id='#{avatar.kata.id}'" +
        " data-avatar-name='#{avatar.name}'" +
        " data-was-tag='-1'" +
        " data-now-tag='-1'>" +
        avatar_image(avatar.name) +
     '</div>'
  end

  def traffic_light_count(avatar)
    lights = avatar.lights
    colour = lights[-1].colour
    "<div class='traffic-light-count #{colour}'" +
        " data-tip='traffic_light_count'" +
        " data-id='#{avatar.kata.id}'" +
        " data-avatar-name='#{avatar.name}'" +
        " data-current-colour='#{colour}'" +
        " data-red-count='#{count(lights, :red)}'" +
        " data-amber-count='#{count(lights, :amber)}'" +
        " data-green-count='#{count(lights, :green)}'" +
        " data-timed-out-count='#{count(lights, :timed_out)}'>" +
      lights.count.to_s +
    '</div>'
  end

  def count(traffic_lights, colour)
     traffic_lights.entries.count { |light| light.colour == colour }
  end

  def avatar_image(avatar_name)
    "<img src='/images/avatars/#{avatar_name}.jpg'" +
        " alt='#{avatar_name}'/>"
  end

  def traffic_light_image(colour)
    "<img src='/images/bulb_#{colour}.png'" +
       " alt='#{colour} traffic-light'/>"
  end

  def apostrophe
    '&#39;'
  end

end
