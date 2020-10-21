class AppHelper
    def self.handle_mars_rover_exceptions 
        error = ""

        begin
            yield
        rescue BadInputException => e            
            error = MarsRoverApp::BAD_INPUT_ERROR
        rescue SkyHighObstacleException => e
            error = MarsRoverApp::SKY_HIGH_OBSTACLE_ERROR
        rescue ObstacleException => e
            error = MarsRoverApp::OBSTACLE_ERROR
        rescue StandardError => e
            error = e.message
        end

        error
    end
end