ENV['APP_ENV'] = 'test'

require "helpers/spec_helper"
require_relative 'helpers/grid_constants'

require_relative '../lib/app_helper'
require_relative '../webapp'
require 'rspec'
require 'rack/test'

RSpec.describe 'The Mars Rover web app' do
    include Rack::Test::Methods
  
    def app
      WebApp
    end
  
    context "on startup" do  
      it "starts with an empty 5x5 grid" do
        # Act
        get '/marsrover'

        # Assert
        expect(last_response).to be_ok
        expect(last_response.body).to include(GridConstants::EMPTY_GRID_WITH_OBSTACLES)
      end
    end

    context "displaying grid" do
        it "remembers grid from previous posts even after multiple GET requests" do   
            # Arrange
            new_rover = GridConstants::NEW_ROVER
            post "/marsrover", :instructions => new_rover
            get '/marsrover'
            
            # Act
            get '/marsrover'
            
            # Assert
            expect(last_response.body).to include(GridConstants::GRID_WITH_NEW_ROVER)
        end
        
        it "adds new rover in response to user input" do   
            # Arrange
            new_rover = GridConstants::NEW_ROVER
            
            # Act
            post "/marsrover", :instructions => new_rover
            
            # Assert
            expect(last_response.body).to include(GridConstants::GRID_WITH_NEW_ROVER)
        end
        
        it "moves rover in response to user input" do   
            # Arrange
            new_rover = GridConstants::NEW_ROVER
            move_rover = GridConstants::REPEATED_MOVEMENTS
            post "/marsrover", :instructions => new_rover
            
            # Act
            post "/marsrover", :instructions => move_rover
            
            # Assert
            expect(last_response.body).to include(GridConstants::GRID_WITH_EAST_FACING_ROVER_AT_2_2)
        end
        
        it "displays error when rover hits obstacle" do   
            # Arrange
            new_rover = GridConstants::NEW_ROVER
            move_rover = GridConstants::MOVEMENTS_FROM_NEW_ROVER_TO_OBSTACLE
            post "/marsrover", :instructions => new_rover
            
            # Act
            post "/marsrover", :instructions => move_rover
            
            # Assert
            expect(last_response.body).to include(ObstacleError::MESSAGE)
        end
    end
end