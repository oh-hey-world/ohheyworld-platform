module CommunitiesHelper

  def locations_number
    countries_number =  @community.locations.length

    if countries_number > 1
      "in #{countries_number} countries"
    else
      "in #{@community.locations[0]}"
    end
  end
end
