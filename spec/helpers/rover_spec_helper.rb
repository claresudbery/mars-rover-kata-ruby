class RoverSpecHelper
    def self.make_real_grid(
            width, 
            height, 
            obstacle_coords=[], 
            sky_high_obstacle_coords=[])
        grid = Grid.new(width, height)
        if !obstacle_coords.empty?
            grid.add_obstacle(obstacle_coords[0], obstacle_coords[1])
        end
        if !sky_high_obstacle_coords.empty?
            grid.add_sky_high_obstacle(sky_high_obstacle_coords[0], sky_high_obstacle_coords[1])
        end
        grid
    end

    def self.make_real_grid_with_rover(
            width, 
            height, 
            x, 
            y, 
            direction, 
            obstacle_coords=[], 
            sky_high_obstacle_coords=[])
        grid = Grid.new(width, height)
        mars_rover = Rover360.new("TST")
        mars_rover.start(x, y, direction, grid)
        if !obstacle_coords.empty?
            grid.add_obstacle(obstacle_coords[0], obstacle_coords[1])
        end
        if !sky_high_obstacle_coords.empty?
            grid.add_sky_high_obstacle(sky_high_obstacle_coords[0], sky_high_obstacle_coords[1])
        end
        grid.update(mars_rover)
        grid
    end

    def self.make_fake_grid(x, y, direction, obstacle_coords=[], sky_high_obstacle_coords=[])  
        fake_grid = double('Grid')
        allow(fake_grid).to receive(:grid_array)
            .and_return(self.make_fake_grid_array(x, y, direction, obstacle_coords_1, obstacle_coords_2))
        fake_grid
    end

    private

    def self.make_fake_grid_array(x, y, direction, obstacle_coords_1=[], obstacle_coords_2=[])        
        # Build a fake 5x5 grid array with a Mars Rover at the specified position and facing the specified direction
        # and with obstacles in the specified locations
    end
end