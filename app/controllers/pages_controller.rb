class PagesController < ApplicationController
  skip_authorize_resource except: [:feedback]
  skip_before_filter :require_login, except: [:feedback]

  def about
  end

  def team
  end

  def privacy
  end

  def tos
  end

  def faq
  end

  def feedback
  end

  def jobs
  end

  def api
  end

  def maintenance
  end

  def happy_customers
  end

  def community_guidelines
  end

  def checking_in
  end

  def welcome_kits_b
    @render_home = true
  end
  
end
