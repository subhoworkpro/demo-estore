class HomeController < ApplicationController

  def index
    # new_path = current_user.andand.agent_view_only? ? agent_view_unanswered_profiles_path : dashboard_path
    # redirect_to(new_path)
  end
end
