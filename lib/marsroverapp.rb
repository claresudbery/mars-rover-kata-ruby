require_relative 'app_helper'

class MarsRoverApp
    def initialize(presenter, communicator, grid, mars_rover_factory)
        @presenter = presenter
        @communicator = communicator
        @grid = grid
        @mars_rover_factory = mars_rover_factory
        @mars_rovers = Hash.new
    end

    def start
        handle_exceptions do
            @presenter.show_display(@grid)
            @communicator.show_message(AppHelper::USER_INFORMATION)
            instructions = @communicator.get_input(AppHelper::REQUEST_FOR_FIRST_INPUT)
            AppHelper::start_rover(instructions, @mars_rovers, @grid, @mars_rover_factory)
            update_display
            move_rover_repeatedly
        end
    end

    private

    def handle_exceptions 
        error = AppHelper.handle_mars_rover_exceptions do
            yield
        end

        if !error.empty?
            puts error
            move_rover_repeatedly
        end
    end

    def move_rover_repeatedly
        instructions = ask_for_further_input
        while !instructions.empty? do
            AppHelper::process_instructions(instructions, @mars_rovers, @grid, @mars_rover_factory)
            update_display
            instructions = ask_for_further_input
        end
    end

    def ask_for_further_input
        @communicator.show_message(AppHelper::USER_INFORMATION)
        instructions = @communicator.get_input(AppHelper::REQUEST_FOR_FURTHER_INPUT)
    end

    def update_display
        @presenter.show_display(@grid)
    end
end