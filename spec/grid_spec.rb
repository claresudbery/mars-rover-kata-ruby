require_relative '../lib/grid'

describe Grid do
    context "grid initialization" do
        it "initializes a grid to the passed-in dimensions" do
            # Arrange
            expected_width = 5
            EXPECTED_HEIGHT = 5

            # Act
            grid = described_class.new(expected_width, EXPECTED_HEIGHT)

            # Assert
            expect(grid.width).to eq(expected_width)
            expect(grid.height).to eq(EXPECTED_HEIGHT)
        end

        it "initializes a grid with all cells empty" do
            # Arrange
            width = 5
            height = 5

            # Act
            grid = described_class.new(width, height)

            # Assert            
            for row in 0...height 
                for col in 0...width 
                    expect(grid.grid_array[col][row]).to eq(Grid::EMPTY_CELL)
                end
            end
        end
    end
    
    context "grid update" do
        it "updates a grid to add the passed-in rover" do
            # Arrange
            expected_x = 2
            expected_y = 3
            expected_direction = StraightLineRover::SOUTH
            grid = described_class.new(5, 5)
            mars_rover = Rover360.new("TST")
            mars_rover.start(expected_x, expected_y, expected_direction, grid)

            # Act
            grid.update(mars_rover)

            # Assert
            expect(grid.grid_array[expected_y][expected_x]).to eq(mars_rover)  
        end

        it "only populates one grid cell when passed a rover" do
            # Arrange
            expected_x = 2
            expected_y = 3
            width = 5
            height = 5
            grid = described_class.new(width, height)
            mars_rover = Rover360.new("TST")
            mars_rover.start(expected_x, expected_y, StraightLineRover::SOUTH, grid)

            # Act
            grid.update(mars_rover)

            # Assert
            expect(grid.grid_array[expected_y][expected_x]).to eq(mars_rover)          
            for row in 0...height 
                for col in 0...width 
                    if (col != expected_y && row != expected_x)
                        expect(grid.grid_array[col][row]).to eq(Grid::EMPTY_CELL)
                    end
                end
            end
        end

        xit "will maintain other rovers when updating the display" do
            # Arrange
            rover1_x = 1
            rover1_y = 1
            grid = described_class.new(5, 5)
            mars_rover1 = Rover360.new("TS1")
            mars_rover1.start(rover1_x, rover1_y, StraightLineRover::SOUTH, grid)
            grid.update(mars_rover1)
            mars_rover2 = Rover360.new("TS1")
            mars_rover2.start(rover1_x + 1, rover1_y + 1, StraightLineRover::NORTH, grid)

            # Act
            grid.update(mars_rover2)

            # Assert
            expect(grid.grid_array[rover1_y][rover1_x]).to eq(mars_rover1)  
        end
    end
    
    context "obstacle management" do
        it "will add an obstacle" do
            # Arrange
            obstacle_x = 4
            obstacle_y = 1
            grid = described_class.new(5, 5)

            # Act
            grid.add_obstacle(obstacle_x, obstacle_y)

            # Assert
            expect(grid.grid_array[obstacle_y][obstacle_x]).to eq(Grid::OBSTACLE)
        end

        it "will add a sky-high obstacle" do
            # Arrange
            obstacle_x = 2
            obstacle_y = 2
            grid = described_class.new(5, 5)

            # Act
            grid.add_sky_high_obstacle(obstacle_x, obstacle_y)

            # Assert
            expect(grid.grid_array[obstacle_y][obstacle_x]).to eq(Grid::SKY_HIGH_OBSTACLE)
        end

        it "will indicate when an obstacle is present" do
            # Arrange
            obstacle_x = 2
            obstacle_y = 3
            grid = described_class.new(5, 5)
            grid.add_obstacle(obstacle_x, obstacle_y)

            # Act
            result = grid.contains_obstacle?(obstacle_x, obstacle_y)

            # Assert
            expect(result).to eq(true)
        end

        it "will count a Mars Rover as an obstacle" do
            # Arrange
            rover_x = 2
            rover_y = 3
            grid = described_class.new(5, 5)
            mars_rover = Rover360.new("TST")
            mars_rover.start(rover_x, rover_y, StraightLineRover::SOUTH, grid)
            grid.update(mars_rover)

            # Act
            result = grid.contains_obstacle?(rover_x, rover_y)

            # Assert
            expect(result).to eq(true)
        end

        it "will maintain obstacles when updating the display" do
            # Arrange
            obstacle_x = 2
            obstacle_y = 3
            grid = described_class.new(5, 5)
            grid.add_obstacle(obstacle_x, obstacle_y)
            mars_rover = Rover360.new("TST")
            mars_rover.start(obstacle_x + 1, obstacle_y + 1, StraightLineRover::SOUTH, grid)            

            # Act
            grid.update(mars_rover)

            # Assert
            expect(grid.grid_array[obstacle_y][obstacle_x]).to eq(Grid::OBSTACLE)  
        end
    end
end