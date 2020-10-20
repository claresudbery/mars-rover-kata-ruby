class NarrowScreenPresenter
    def show_display(grid)
        show_narrow_screen_grid(grid.grid_array)
    end

    private

    def show_narrow_screen_grid(grid_array)
        # Turn grid array into something that looks something like this:
        # (Note that this is an advanced imagined future version 
        # with obstacles and multiple named rovers)
        
        # ----------------
        # |  |  |  |  |  |
        # |  |  |  |  |  |
        # ----------------
        # |A |  |XX|  |  |
        # | v|  |XX|  |  |
        # ----------------
        # |  |XX|  |  | ^|
        # |  |XX|  |  |B |
        # ----------------
        # |  |  |  | C|  |
        # |  |  |  |< |  |
        # ----------------
        # |  |D |  |  |  |
        # |  | >|  |  |  |
        # ----------------
    end
end