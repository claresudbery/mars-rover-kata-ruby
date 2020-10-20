require_relative '../../lib/presenters/wide_screen_grid'
require_relative '../../lib/grid'
require_relative '../helpers/rover_spec_helper'

describe WideScreenGrid do
    context "#display_row" do	
        it "converts an empty single-cell grid row into a beautiful display" do
            # Arrange
            display_grid = WideScreenGrid.new
            cells = [""]
            empty_cell = 
            <<~HEREDOC
            -------
            |     |
            |     |
            |     |
            HEREDOC

            # Act
            result = display_grid.display_row(cells)

            # Assert
            expect(result).to eq(empty_cell)
        end

        it "converts an empty multi-cell grid row into a beautiful display" do
            # Arrange
            display_grid = WideScreenGrid.new
            cells = ["", "", ""]
            empty_row = 
            <<~HEREDOC
            -------------------
            |     |     |     |
            |     |     |     |
            |     |     |     |
            HEREDOC

            # Act
            result = display_grid.display_row(cells)

            # Assert
            expect(result).to eq(empty_row)
        end

        it "converts a single-cell grid row containing a Rover into a beautiful display" do
            # Arrange
            display_grid = WideScreenGrid.new
            grid_stub = double("Grid")
            allow(grid_stub).to receive(:contains_obstacle?)
            rover = Rover360.new("MAX")
            rover.start(0, 0, Rover360::EAST, grid_stub)
            cells = [rover]
            populated_cell = 
            <<~HEREDOC
            -------
            | 360 |
            | >>> |
            | MAX |
            HEREDOC

            # Act
            result = display_grid.display_row(cells)

            # Assert
            expect(result).to eq(populated_cell)
        end

        it "converts a multi-cell grid row containing a Rover into a beautiful display" do
            # Arrange
            display_grid = WideScreenGrid.new
            grid_stub = double("Grid")
            allow(grid_stub).to receive(:contains_obstacle?)
            rover = StraightLineRover.new("ANN")
            rover.start(0, 0, StraightLineRover::SOUTH, grid_stub)
            cells = ["", rover, ""]
            populated_row = 
            <<~HEREDOC
            -------------------
            |     | SLR |     |
            |     | vvv |     |
            |     | ANN |     |
            HEREDOC

            # Act
            result = display_grid.display_row(cells)

            # Assert
            expect(result).to eq(populated_row)
        end
    end	

    context "#row_line" do
        it "constructs a single-celled empty row line" do
            # Arrange
            display_grid = WideScreenGrid.new
            cells = [""]
            empty_row_line = "|     |\n"

            # Act
            result = display_grid.row_line(cells, 0)

            # Assert
            expect(result).to eq(empty_row_line)
        end
        
        it "constructs a multi-celled empty row line" do
            # Arrange
            display_grid = WideScreenGrid.new
            cells = ["", "", "", ""]
            empty_row_line = "|     |     |     |     |\n"

            # Act
            result = display_grid.row_line(cells, 0)

            # Assert
            expect(result).to eq(empty_row_line)
        end

        it "constructs a single-celled row line containing the first row of an obstacle" do
            # Arrange
            display_grid = WideScreenGrid.new
            cells = [Grid::OBSTACLE]
            expected_row_line = "| X X |\n"

            # Act
            result = display_grid.row_line(cells, 0)

            # Assert
            expect(result).to eq(expected_row_line)
        end

        it "constructs a single-celled row line containing the second row of an obstacle" do
            # Arrange
            display_grid = WideScreenGrid.new
            cells = [Grid::OBSTACLE]
            expected_row_line = "|  X  |\n"

            # Act
            result = display_grid.row_line(cells, 1)

            # Assert
            expect(result).to eq(expected_row_line)
        end

        it "constructs a single-celled row line containing the third row of an obstacle" do
            # Arrange
            display_grid = WideScreenGrid.new
            cells = [Grid::OBSTACLE]
            expected_row_line = "| X X |\n"

            # Act
            result = display_grid.row_line(cells, 2)

            # Assert
            expect(result).to eq(expected_row_line)
        end

        it "constructs a single-celled row line containing the first row of a sky-high obstacle" do
            # Arrange
            display_grid = WideScreenGrid.new
            cells = [Grid::SKY_HIGH_OBSTACLE]
            expected_row_line = "| SKY |\n"

            # Act
            result = display_grid.row_line(cells, 0)

            # Assert
            expect(result).to eq(expected_row_line)
        end

        it "constructs a single-celled row line containing the second row of a sky-high obstacle" do
            # Arrange
            display_grid = WideScreenGrid.new
            cells = [Grid::SKY_HIGH_OBSTACLE]
            expected_row_line = "|  X  |\n"

            # Act
            result = display_grid.row_line(cells, 1)

            # Assert
            expect(result).to eq(expected_row_line)
        end

        it "constructs a single-celled row line containing the third row of a sky-high obstacle" do
            # Arrange
            display_grid = WideScreenGrid.new
            cells = [Grid::SKY_HIGH_OBSTACLE]
            expected_row_line = "| HIGH|\n"

            # Act
            result = display_grid.row_line(cells, 2)

            # Assert
            expect(result).to eq(expected_row_line)
        end

        it "constructs a single-celled row line containing the first row of a Rover360" do
            # Arrange
            display_grid = WideScreenGrid.new
            rover = Rover360.new("TST")
            cells = [rover]
            expected_row_line = "| 360 |\n"

            # Act
            result = display_grid.row_line(cells, 0)

            # Assert
            expect(result).to eq(expected_row_line)
        end

        it "constructs a single-celled row line containing the first row of a straight-line Rover" do
            # Arrange
            display_grid = WideScreenGrid.new
            rover = StraightLineRover.new("TST")
            cells = [rover]
            expected_row_line = "| SLR |\n"

            # Act
            result = display_grid.row_line(cells, 0)

            # Assert
            expect(result).to eq(expected_row_line)
        end

        it "constructs a single-celled row line containing the first row of a flying Rover" do
            # Arrange
            display_grid = WideScreenGrid.new
            rover = FlyingRover.new("TST")
            cells = [rover]
            expected_row_line = "| FLY |\n"

            # Act
            result = display_grid.row_line(cells, 0)

            # Assert
            expect(result).to eq(expected_row_line)
        end

        it "constructs a single-celled row line containing the second row of a North-facing Rover" do
            # Arrange
            display_grid = WideScreenGrid.new
            grid_stub = double("Grid")
            allow(grid_stub).to receive(:contains_obstacle?)
            rover = Rover360.new("TST")
            rover.start(0, 0, StraightLineRover::NORTH, grid_stub)
            cells = [rover]
            expected_row_line = "| ^^^ |\n"

            # Act
            result = display_grid.row_line(cells, 1)

            # Assert
            expect(result).to eq(expected_row_line)
        end

        it "constructs a single-celled row line containing the second row of a South-facing Rover" do
            # Arrange
            display_grid = WideScreenGrid.new
            grid_stub = double("Grid")
            allow(grid_stub).to receive(:contains_obstacle?)
            rover = Rover360.new("TST")
            rover.start(0, 0, StraightLineRover::SOUTH, grid_stub)
            cells = [rover]
            expected_row_line = "| vvv |\n"

            # Act
            result = display_grid.row_line(cells, 1)

            # Assert
            expect(result).to eq(expected_row_line)
        end

        it "constructs a single-celled row line containing the second row of an East-facing Rover" do
            # Arrange
            display_grid = WideScreenGrid.new
            grid_stub = double("Grid")
            allow(grid_stub).to receive(:contains_obstacle?)
            rover = Rover360.new("TST")
            rover.start(0, 0, Rover360::EAST, grid_stub)
            cells = [rover]
            expected_row_line = "| >>> |\n"

            # Act
            result = display_grid.row_line(cells, 1)

            # Assert
            expect(result).to eq(expected_row_line)
        end

        it "constructs a single-celled row line containing the second row of a West-facing Rover" do
            # Arrange
            display_grid = WideScreenGrid.new
            grid_stub = double("Grid")
            allow(grid_stub).to receive(:contains_obstacle?)
            rover = Rover360.new("TST")
            rover.start(0, 0, Rover360::WEST, grid_stub)
            cells = [rover]
            expected_row_line = "| <<< |\n"

            # Act
            result = display_grid.row_line(cells, 1)

            # Assert
            expect(result).to eq(expected_row_line)
        end

        it "constructs a single-celled row line containing the third row of a Rover called MEG" do
            # Arrange
            display_grid = WideScreenGrid.new
            rover = Rover360.new("MEG")
            cells = [rover]
            expected_row_line = "| MEG |\n"

            # Act
            result = display_grid.row_line(cells, 2)

            # Assert
            expect(result).to eq(expected_row_line)
        end
    end

    context "#display_wall" do
        it "constructs a single-celled bottom wall" do
            # Arrange
            display_grid = WideScreenGrid.new
            expected_wall = "-------\n"

            # Act
            result = display_grid.display_wall(1)

            # Assert
            expect(result).to eq(expected_wall)
        end

        it "constructs a multi-celled bottom wall" do
            # Arrange
            display_grid = WideScreenGrid.new
            expected_wall = "-------------------\n"

            # Act
            result = display_grid.display_wall(3)

            # Assert
            expect(result).to eq(expected_wall)
        end
    end
end