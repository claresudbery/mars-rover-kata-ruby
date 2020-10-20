require_relative '../../lib/presenters/wide_screen_presenter'
require_relative '../../lib/grid'
require_relative '../helpers/rover_spec_helper'

describe WideScreenPresenter do
    context "#show_display" do
        it "converts an empty 2x3 grid into a beautiful display" do
            # Arrange
            presenter = described_class.new
            grid = Grid.new(2, 3)
            empty_grid = 
            <<~HEREDOC
            -------------
            |     |     |
            |     |     |
            |     |     |
            -------------
            |     |     |
            |     |     |
            |     |     |
            -------------
            |     |     |
            |     |     |
            |     |     |
            -------------
            HEREDOC

            # Act/Assert
            expect{presenter.show_display(grid)}.to output(empty_grid).to_stdout
        end

        it "converts a 2x3 grid containing an obstacle into an informative display" do
            # Arrange
            presenter = described_class.new
            grid = RoverSpecHelper.make_real_grid(2, 3, [1,1])
            populated_grid = 
            <<~HEREDOC
            -------------
            |     |     |
            |     |     |
            |     |     |
            -------------
            |     | X X |
            |     |  X  |
            |     | X X |
            -------------
            |     |     |
            |     |     |
            |     |     |
            -------------
            HEREDOC

            # Act/Assert
            expect{presenter.show_display(grid)}.to output(populated_grid).to_stdout
        end

        it "converts a 2x3 grid containing a sky-high obstacle into an informative display" do
            # Arrange
            presenter = described_class.new
            grid = RoverSpecHelper.make_real_grid(2, 3, [], [1,0])
            populated_grid = 
            <<~HEREDOC
            -------------
            |     | SKY |
            |     |  X  |
            |     | HIGH|
            -------------
            |     |     |
            |     |     |
            |     |     |
            -------------
            |     |     |
            |     |     |
            |     |     |
            -------------
            HEREDOC

            # Act/Assert
            expect{presenter.show_display(grid)}.to output(populated_grid).to_stdout
        end

        it "converts a 2x3 grid (containing a Mars Rover facing North) into an informative display" do
            # Arrange
            presenter = described_class.new
            grid = RoverSpecHelper.make_real_grid_with_rover(2, 3, 1, 2, StraightLineRover::NORTH)
            populated_grid = 
            <<~HEREDOC
            -------------
            |     |     |
            |     |     |
            |     |     |
            -------------
            |     |     |
            |     |     |
            |     |     |
            -------------
            |     | 360 |
            |     | ^^^ |
            |     | TST |
            -------------
            HEREDOC

            # Act/Assert
            expect{presenter.show_display(grid)}.to output(a_string_including(populated_grid)).to_stdout
        end

        it "converts a 2x3 grid (containing a Mars Rover facing South) into an informative display" do
            # Arrange
            presenter = described_class.new
            grid = RoverSpecHelper.make_real_grid_with_rover(2, 3, 1, 1, StraightLineRover::SOUTH)
            populated_grid = 
            <<~HEREDOC
            -------------
            |     |     |
            |     |     |
            |     |     |
            -------------
            |     | 360 |
            |     | vvv |
            |     | TST |
            -------------
            |     |     |
            |     |     |
            |     |     |
            -------------
            HEREDOC

            # Act/Assert
            expect{presenter.show_display(grid)}.to output(populated_grid).to_stdout
        end

        it "converts a 2x3 grid (containing a Mars Rover facing East) into an informative display" do
            # Arrange
            presenter = described_class.new
            grid = RoverSpecHelper.make_real_grid_with_rover(2, 3, 1, 0, StraightLineRover::EAST)
            populated_grid = 
            <<~HEREDOC
            -------------
            |     | 360 |
            |     | >>> |
            |     | TST |
            -------------
            |     |     |
            |     |     |
            |     |     |
            -------------
            |     |     |
            |     |     |
            |     |     |
            -------------
            HEREDOC

            # Act/Assert
            expect{presenter.show_display(grid)}.to output(populated_grid).to_stdout
        end

        it "converts a 2x3 grid (containing a Mars Rover facing West) into an informative display" do
            # Arrange
            presenter = described_class.new
            grid = RoverSpecHelper.make_real_grid_with_rover(2, 3, 0, 1, StraightLineRover::WEST)
            populated_grid = 
            <<~HEREDOC
            -------------
            |     |     |
            |     |     |
            |     |     |
            -------------
            | 360 |     |
            | <<< |     |
            | TST |     |
            -------------
            |     |     |
            |     |     |
            |     |     |
            -------------
            HEREDOC

            # Act/Assert
            expect{presenter.show_display(grid)}.to output(populated_grid).to_stdout
        end

        it "converts a 2x3 grid containing obstacles and a rover into an informative display" do
            # Arrange
            presenter = described_class.new
            grid = RoverSpecHelper.make_real_grid_with_rover(2, 3, 0, 2, StraightLineRover::NORTH, [1,1], [1,0])
            populated_grid = 
            <<~HEREDOC
            -------------
            |     | SKY |
            |     |  X  |
            |     | HIGH|
            -------------
            |     | X X |
            |     |  X  |
            |     | X X |
            -------------
            | 360 |     |
            | ^^^ |     |
            | TST |     |
            -------------
            HEREDOC

            # Act/Assert
            expect{presenter.show_display(grid)}.to output(populated_grid).to_stdout
        end
    end
end