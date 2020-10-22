class SkyHighObstacleError < ObstacleError
    MESSAGE = "Oh no, I'm sorry, I can't process that instruction. There is a sky-high obstacle in the way!"
    
    def initialize(msg = MESSAGE)
        super
    end
end