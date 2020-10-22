class ObstacleError < StandardError
    MESSAGE = "Oh no, I'm sorry, I can't process that instruction. There is an obstacle in the way!"
        
    def initialize(msg = MESSAGE)
        super
    end
end