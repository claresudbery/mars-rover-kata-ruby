class BadInputError < StandardError
    MESSAGE = "Sorry, I don't understand that input."
    
    def initialize(msg = MESSAGE)
        super
    end
end