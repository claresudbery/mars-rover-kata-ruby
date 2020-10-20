class Communicator
    def show_message(message)
        puts message
    end

    def get_input(input_prompt)
        puts input_prompt
        stdinput = gets.chomp
        if is_invalid?(stdinput)
            raise BadInputException.new
        end
        stdinput
    end

    def is_invalid?(input)
        false
    end
end