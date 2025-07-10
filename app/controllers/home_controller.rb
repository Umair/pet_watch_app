class HomeController < ApplicationController
  def index
    @reviews = [
      { name: 'Alice', content: 'Pet Watch made it so easy to keep track of my dog’s vaccinations!' },
      { name: 'Bob', content: 'Love the reminders and the simple interface.' },
      { name: 'Carla', content: 'Highly recommend for all pet owners!' }
    ]
    @user = current_user
  end
end
