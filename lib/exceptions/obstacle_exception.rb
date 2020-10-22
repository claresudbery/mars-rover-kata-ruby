class ObstacleException < StandardError
    OBSTACLE_ERROR = "Oh no, I'm sorry, I can't process that instruction. There is an obstacle in the way!"
        
    def initialize(msg = OBSTACLE_ERROR)
        super
    end
end