require_relative 'lib/presenters/webpresenter'
require_relative 'lib/presenters/narrow_screen_presenter'
require_relative 'lib/presenters/wide_screen_presenter'
require_relative 'lib/communicator'
require_relative 'lib/grid'
require_relative 'lib/marsroverapp'
require_relative 'lib/rovers/mars_rover_factory'

$stdout.sync = true

mars_rover_factory = MarsRoverFactory.new
grid = Grid.new(5, 5)
grid.add_obstacle(3,2)
grid.add_sky_high_obstacle(2,3)
wide_screen_presenter = WideScreenPresenter.new
narrow_screen_presenter = NarrowScreenPresenter.new
web_presenter = WebPresenter.new(5, 5)
communicator = Communicator.new

define_method :choose_presenter do
    case ask_user_which_presenter_they_prefer
        when :wide_screen
            {   
                :presenter => wide_screen_presenter,
                :communicator => communicator,
                :grid => grid
            }
        when :narrow_screen
            {   
                :presenter => narrow_screen_presenter,
                :communicator => communicator,
                :grid => grid
            }
        when :web
            {   
                :presenter => web_presenter,
                :communicator => web_presenter,
                :grid => web_presenter
            }
    end
end

define_method :ask_user_which_presenter_they_prefer do
    # ask user to decide between the multiple types of presenter
    # For now, defaulting to wide screen.
    :wide_screen
end

user_choice = choose_presenter

my_app = MarsRoverApp.new(
    user_choice[:presenter], 
    user_choice[:communicator], 
    user_choice[:grid], 
    mars_rover_factory)

my_app.start