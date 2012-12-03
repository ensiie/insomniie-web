class Users::SettingsController < ApplicationController
  def change_theme
    session['canada'] = !session['canada']
    redirect_to '/'
  end
end
