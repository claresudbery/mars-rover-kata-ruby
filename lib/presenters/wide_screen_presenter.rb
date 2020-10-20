require_relative "wide_screen_grid"

class WideScreenPresenter
    def initialize
        @wide_screen_grid = WideScreenGrid.new
    end

    def show_display(grid)
        show_wide_screen_grid(grid.grid_array)        
    end

    private

    def show_wide_screen_grid(grid_array)  
        display = ""
        grid_array.each do |row|
            display = display + @wide_screen_grid.display_row(row)
        end
        display = display + @wide_screen_grid.display_wall(grid_array[0].length)
        puts display
    end
end