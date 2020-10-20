class WebPresenter
    # Grid interface

    attr_accessor :grid_array

    def initialize(width, height)
        @width = width
        @height = height
        @grid_array = make_grid(width, height)
    end

    def update(mars_rover)
    end

    def add_obstacle(x, y)
    end

    def contains_obstacle?(x, y)
    end

    # Presenter interface

    def show_display(grid)
    end

    # Communicator interface

    def get_input(input_prompt)
    end

    def is_invalid?(input)
    end
    
    private

    def make_grid (width, height)
        # build a (width x height) empty data structure
    end
end