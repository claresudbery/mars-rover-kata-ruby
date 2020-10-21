ENV['APP_ENV'] = 'test'

require "helpers/spec_helper"
require_relative 'helpers/grid_constants'

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
        expect(last_response.body).to have_tag('pre', :text => /"#{GridConstants::EMPTY_GRID_WITH_OBSTACLES}"/)
      end
    end
  
    context "responding to input" do  
        it "displays user input" do
            # Arrange
            some_input = "SOME INPUT"

            # Act
            post "/marsrover", :instructions => some_input 

            # Assert
            expect(last_response).to be_ok
            expect(last_response.body).to have_tag('pre', :text => "#{some_input}")
        end
    end

    context "displaying grid" do
        it "remembers grid from previous posts even after multiple GET requests" do   
            # Arrange
            some_input = "ANN,360,0,0,N"
            post "/marsrover", :instructions => some_input
            get '/marsrover'
            
            # Act
            get '/marsrover'
            
            # Assert
            expect(last_response.body).to have_tag('pre', :text => /"#{GridConstants::EMPTY_GRID_WITH_OBSTACLES}"/)
        end
        
        it "updates grid in response to user input" do   
            # Arrange
            some_input = "ANN,360,0,0,N"
            post "/marsrover", :instructions => some_input
            get '/marsrover'
            
            # Act
            get '/marsrover'
            
            # Assert
            expect(last_response.body).to have_tag('pre', :text => /"#{GridConstants::GRID_WITH_NEW_ROVER}"/)
        end
    end
end