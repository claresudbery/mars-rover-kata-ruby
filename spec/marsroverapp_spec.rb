require_relative '../lib/presenters/wide_screen_presenter'
require_relative '../lib/communicator'
require_relative '../lib/grid'
require_relative '../lib/rovers/mars_rover_factory'
require_relative '../lib/marsroverapp'

class MarsRoverAppTests
    OBSTACLE_X = 3
    OBSTACLE_Y = 2
    SKY_HIGH_OBSTACLE_X = 2
    SKY_HIGH_OBSTACLE_Y = 3

    describe MarsRoverApp do

        before(:each) do
            @presenter = WideScreenPresenter.new
            @communicator = Communicator.new
            @grid = Grid.new(5, 5)
            @grid.add_obstacle(MarsRoverAppTests::OBSTACLE_X, MarsRoverAppTests::OBSTACLE_Y)
            @grid.add_sky_high_obstacle(MarsRoverAppTests::SKY_HIGH_OBSTACLE_X, MarsRoverAppTests::SKY_HIGH_OBSTACLE_Y) 
            @mars_rover_factory = MarsRoverFactory.new
            @mars_rover_app = MarsRoverApp.new(@presenter, @communicator, @grid, @mars_rover_factory)
        end
        
        context "on startup" do
            it "can display an empty 3x2 grid containing no obstacles on startup" do
                # Arrange
                presenter = WideScreenPresenter.new
                communicator = Communicator.new
                grid = Grid.new(3, 2)
                mars_rover_factory = MarsRoverFactory.new
                mars_rover_app = MarsRoverApp.new(presenter, communicator, grid, mars_rover_factory)
                initial_input = "ANN,360,0,0,N"
                empty_grid = 
                <<~HEREDOC
                -------------------
                |     |     |     |
                |     |     |     |
                |     |     |     |
                -------------------
                |     |     |     |
                |     |     |     |
                |     |     |     |
                -------------------
                HEREDOC
                allow(communicator).to receive(:gets).and_return(initial_input, "")

                # Act/Assert
                expect{mars_rover_app.start}.to output(a_string_starting_with(empty_grid)).to_stdout
            end

            it "displays an empty 5x5 grid containing obstacles on startup" do
                # Arrange
                initial_input = "ANN,360,0,0,N"         
                empty_grid_with_obstacles = 
                <<~HEREDOC
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                |     |     |     | X X |     |
                |     |     |     |  X  |     |
                |     |     |     | X X |     |
                -------------------------------
                |     |     | SKY |     |     |
                |     |     |  X  |     |     |
                |     |     | HIGH|     |     |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                HEREDOC
                allow(@communicator).to receive(:gets).and_return(initial_input, "")

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_starting_with(empty_grid_with_obstacles)).to_stdout
            end

            it "prompts the user to input coordinates and direction on startup" do
                # Arrange
                initial_input = "ANN,360,0,0,N"
                expected_prompt = MarsRoverApp::REQUEST_FOR_FIRST_INPUT
                allow(@communicator).to receive(:gets).and_return(initial_input, "")

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_including(expected_prompt)).to_stdout
            end
        end

        context "detecting invalid input" do
            xit "shows an error when the initial input is invalid" do
                # Arrange
                bad_input = "ANN,BBB,0,0,N"
                allow(@communicator).to receive(:gets).and_return("!") 

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_ending_with("#{MarsRoverApp::BAD_INPUT_ERROR}\n")).to_stdout
            end
        
            xit "shows an error when the first movement input is invalid" do
                # Arrange
                initial_input = "ANN,360,0,0,N"
                bad_input = "ANN,x"
                allow(@communicator).to receive(:gets).and_return(initial_input, bad_input, "")

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_ending_with("#{MarsRoverApp::BAD_INPUT_ERROR}\n")).to_stdout
            end
        
            xit "shows an error when a later movement input is invalid" do
                # Arrange
                initial_input = "ANN,360,0,0,N"
                bad_input = "MAX,b"
                allow(@communicator).to receive(:gets).and_return(initial_input, "ANN,f", "ANN,r", "ANN,l", bad_input, "") 

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_ending_with("#{MarsRoverApp::BAD_INPUT_ERROR}\n")).to_stdout
            end
        
            xit "shows an error when a later new-rover input is invalid" do
                # Arrange
                initial_input = "ANN,360,0,0,N"
                bad_input = "MAX,360,0,0,X"
                allow(@communicator).to receive(:gets).and_return(initial_input, "ANN,f", "ANN,r", "ANN,l", bad_input, "") 

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_ending_with("#{MarsRoverApp::BAD_INPUT_ERROR}\n")).to_stdout
            end
        end

        context "when moving (using test doubles)" do
            it "displays the position of a Rover when given position" do
                # Arrange
                grid_with_new_rover = "This is what we think a 5x5 grid with a North-facing Rover at 0,0 will look like."
                rover_factory_stub = double('MarsRoverFactory')
                allow(rover_factory_stub).to receive(:generate_rover) 
                grid_stub = double('Grid')
                allow(grid_stub).to receive(:contains_obstacle?) 
                communicator_stub = double('Communicator')
                allow(communicator_stub).to receive(:show_message) 
                fake_presenter = double('Presenter')
                allow(fake_presenter).to receive(:show_display).with(grid_stub) {puts grid_with_new_rover}
                expected_input = "ANN,360,0,0,N"
                allow(communicator_stub).to receive(:get_input).and_return(expected_input, "") 
                mars_rover_app = MarsRoverApp.new(fake_presenter, communicator_stub, grid_stub, rover_factory_stub)

                # Act/Assert
                expect{mars_rover_app.start}.to output(a_string_starting_with(grid_with_new_rover)).to_stdout
            end
        end

        context "when moving (using test spies)" do
            it "uses the rover, the grid and the presenter to update the Rover's position" do
                # Arrange
                grid_with_new_rover = "This is what we think a 5x5 grid with a North-facing Rover at 0,0 will look like."
                mars_rover_spy = spy('Rover360')
                rover_factory_fake = double('MarsRoverFactory')
                allow(rover_factory_fake).to receive(:generate_rover).with("ANN","360").and_return(mars_rover_spy)
                grid_spy = spy('Grid')
                allow(grid_spy).to receive(:contains_obstacle?).and_return(false)
                communicator_stub = double('Communicator')
                allow(communicator_stub).to receive(:show_message) 
                presenter_spy = spy('Presenter')
                allow(presenter_spy).to receive(:show_display).with(grid_spy) {puts grid_with_new_rover}
                expected_input = "ANN,360,0,0,N"
                allow(communicator_stub).to receive(:get_input).and_return(expected_input, "") 
                mars_rover_app = MarsRoverApp.new(presenter_spy, communicator_stub, grid_spy, rover_factory_fake)

                # Act/Assert
                expect{mars_rover_app.start}.to output(a_string_starting_with(grid_with_new_rover)).to_stdout
                expect(rover_factory_fake).to have_received(:generate_rover).with("ANN","360")
                expect(mars_rover_spy).to have_received(:start)
                expect(grid_spy).to have_received(:update).with(mars_rover_spy)
            end
        end

        context "when moving (proper end to end test)" do
            it "displays the position of a Rover when given position" do
                # Arrange
                expected_input = "ANN,360,0,0,N"
                allow(@communicator).to receive(:gets).and_return(expected_input, "") 
                grid_with_new_rover = 
                <<~HEREDOC
                -------------------------------
                | 360 |     |     |     |     |
                | ^^^ |     |     |     |     |
                | ANN |     |     |     |     |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                |     |     |     | X X |     |
                |     |     |     |  X  |     |
                |     |     |     | X X |     |
                -------------------------------
                |     |     | SKY |     |     |
                |     |     |  X  |     |     |
                |     |     | HIGH|     |     |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                HEREDOC

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_including(grid_with_new_rover)).to_stdout
            end
            
            it "shows an error if the start position is invalid because an obstacle is in the way" do
                # Arrange
                expected_input = "ANN,360,#{OBSTACLE_X},#{OBSTACLE_Y},N"
                allow(@communicator).to receive(:gets).and_return(expected_input, "") 

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_ending_with("#{MarsRoverApp::OBSTACLE_ERROR}\n")).to_stdout
            end

            it "prompts the user to input movement or new direction after first input" do
                # Arrange
                expected_input = "ANN,360,0,0,N"
                allow(@communicator).to receive(:gets).and_return(expected_input, "") 
                expected_prompt = MarsRoverApp::REQUEST_FOR_FURTHER_INPUT

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_including(expected_prompt)).to_stdout
            end
            
            it "updates the direction of a Rover when it turns left" do
                # Arrange
                initial_input = "ANN,360,0,0,N"
                expected_move_input = "ANN,l"
                allow(@communicator).to receive(:gets).and_return(initial_input, expected_move_input, "") 
                grid_with_west_facing_rover = 
                <<~HEREDOC
                -------------------------------
                | 360 |     |     |     |     |
                | <<< |     |     |     |     |
                | ANN |     |     |     |     |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                |     |     |     | X X |     |
                |     |     |     |  X  |     |
                |     |     |     | X X |     |
                -------------------------------
                |     |     | SKY |     |     |
                |     |     |  X  |     |     |
                |     |     | HIGH|     |     |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                HEREDOC

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_including(grid_with_west_facing_rover)).to_stdout
            end
            
            it "updates the direction of a Rover when it turns right" do
                # Arrange
                initial_input = "ANN,360,0,0,N"
                expected_move_input = "ANN,r"
                allow(@communicator).to receive(:gets).and_return(initial_input, expected_move_input, "") 
                grid_with_east_facing_rover = 
                <<~HEREDOC
                -------------------------------
                | 360 |     |     |     |     |
                | >>> |     |     |     |     |
                | ANN |     |     |     |     |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                |     |     |     | X X |     |
                |     |     |     |  X  |     |
                |     |     |     | X X |     |
                -------------------------------
                |     |     | SKY |     |     |
                |     |     |  X  |     |     |
                |     |     | HIGH|     |     |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                HEREDOC

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_including(grid_with_east_facing_rover)).to_stdout
            end
            
            it "updates the position of a Rover when it moves forwards" do
                # Arrange
                initial_input = "ANN,360,4,4,N"
                expected_move_input = "ANN,f"
                allow(@communicator).to receive(:gets).and_return(initial_input, expected_move_input, "") 
                expected_grid = 
                <<~HEREDOC
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                |     |     |     | X X |     |
                |     |     |     |  X  |     |
                |     |     |     | X X |     |
                -------------------------------
                |     |     | SKY |     | 360 |
                |     |     |  X  |     | ^^^ |
                |     |     | HIGH|     | ANN |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                HEREDOC

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_including(expected_grid)).to_stdout
            end
            
            it "updates the position of a Rover when it moves backwards" do
                # Arrange
                initial_input = "ANN,360,0,0,N"
                expected_move_input = "ANN,b"
                allow(@communicator).to receive(:gets).and_return(initial_input, expected_move_input, "") 
                expected_grid = 
                <<~HEREDOC
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                | 360 |     |     |     |     |
                | ^^^ |     |     |     |     |
                | ANN |     |     |     |     |
                -------------------------------
                |     |     |     | X X |     |
                |     |     |     |  X  |     |
                |     |     |     | X X |     |
                -------------------------------
                |     |     | SKY |     |     |
                |     |     |  X  |     |     |
                |     |     | HIGH|     |     |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                HEREDOC

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_including(expected_grid)).to_stdout
            end
            
            it "wraps around when it moves forward off the edge of the grid" do
                # Arrange
                initial_input = "ANN,360,4,4,S"
                expected_move_input = "ANN,f"
                allow(@communicator).to receive(:gets).and_return(initial_input, expected_move_input, "") 
                expected_grid = 
                <<~HEREDOC
                -------------------------------
                |     |     |     |     | 360 |
                |     |     |     |     | vvv |
                |     |     |     |     | ANN |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                |     |     |     | X X |     |
                |     |     |     |  X  |     |
                |     |     |     | X X |     |
                -------------------------------
                |     |     | SKY |     |     |
                |     |     |  X  |     |     |
                |     |     | HIGH|     |     |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                HEREDOC

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_including(expected_grid)).to_stdout
            end
            
            it "wraps around when it moves backwards off the edge of the grid" do
                # Arrange
                initial_input = "ANN,360,4,0,S"
                expected_move_input = "ANN,b"
                allow(@communicator).to receive(:gets).and_return(initial_input, expected_move_input, "") 
                expected_grid = 
                <<~HEREDOC
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                |     |     |     | X X |     |
                |     |     |     |  X  |     |
                |     |     |     | X X |     |
                -------------------------------
                |     |     | SKY |     |     |
                |     |     |  X  |     |     |
                |     |     | HIGH|     |     |
                -------------------------------
                |     |     |     |     | 360 |
                |     |     |     |     | vvv |
                |     |     |     |     | ANN |
                -------------------------------
                HEREDOC

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_including(expected_grid)).to_stdout
            end
            
            it "responds to repeated movement inputs" do
                # Arrange
                initial_input = "ANN,360,0,0,N"
                allow(@communicator).to receive(:gets).and_return(initial_input, "ANN,f", "ANN,r", "ANN,f", "ANN,f", "ANN,f", "ANN,l", "ANN,b", "") 
                expected_grid = 
                <<~HEREDOC
                -------------------------------
                |     |     |     | 360 |     |
                |     |     |     | ^^^ |     |
                |     |     |     | ANN |     |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                |     |     |     | X X |     |
                |     |     |     |  X  |     |
                |     |     |     | X X |     |
                -------------------------------
                |     |     | SKY |     |     |
                |     |     |  X  |     |     |
                |     |     | HIGH|     |     |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                HEREDOC

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_including(expected_grid)).to_stdout
            end
            
            it "responds to several movements in one input" do
                # Arrange
                initial_input = "ANN,360,0,0,N"
                allow(@communicator).to receive(:gets).and_return(initial_input, "ANN,b,r,f,f,l,b,r", "") 
                expected_grid = 
                <<~HEREDOC
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                |     |     | 360 | X X |     |
                |     |     | >>> |  X  |     |
                |     |     | ANN | X X |     |
                -------------------------------
                |     |     | SKY |     |     |
                |     |     |  X  |     |     |
                |     |     | HIGH|     |     |
                -------------------------------
                |     |     |     |     |     |
                |     |     |     |     |     |
                |     |     |     |     |     |
                -------------------------------
                HEREDOC

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_including(expected_grid)).to_stdout
            end
            
            it "shows an error when the rover can't move forward because there is an obstacle in the way" do
                # Arrange
                initial_input = "ANN,360,0,0,N"
                expected_move_input = "ANN,f"
                @grid.add_obstacle(0,4)
                allow(@communicator).to receive(:gets).and_return(initial_input, expected_move_input, "") 

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_ending_with("#{MarsRoverApp::OBSTACLE_ERROR}\n")).to_stdout
            end
            
            it "shows an error when the rover can't move backwards because there is an obstacle in the way" do
                # Arrange
                initial_input = "ANN,360,4,4,N"
                expected_move_input = "ANN,b"
                @grid.add_obstacle(4,0)
                allow(@communicator).to receive(:gets).and_return(initial_input, expected_move_input, "") 

                # Act/Assert
                expect{@mars_rover_app.start}.to output(a_string_ending_with("#{MarsRoverApp::OBSTACLE_ERROR}\n")).to_stdout
            end
        end
    end
end