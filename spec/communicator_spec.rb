require_relative '../lib/communicator'
require_relative '../lib/grid'

describe Communicator do     
    context "#show_message" do
        it "outputs the specified message" do
            # Arrange
            communicator = described_class.new
            expected_message = "Here is lots of useful information for the user."

            # Act/Assert
            expect{communicator.show_message(expected_message)}.to output(a_string_starting_with(expected_message)).to_stdout
        end
    end 

    context "#get_input" do
        it "outputs the specified input prompt" do
            # Arrange
            communicator = described_class.new
            expected_input_prompt = "Give me some input pretty pls"
            allow(communicator).to receive(:gets).and_return("Some input") 

            # Act/Assert
            expect{communicator.get_input(expected_input_prompt)}.to output(a_string_starting_with(expected_input_prompt)).to_stdout
        end
        
        it "returns stdin" do
            # Arrange
            communicator = described_class.new
            expected_input = "Here's my input thx bye"
            allow(communicator).to receive(:gets).and_return(expected_input)

            # Act
            user_input = communicator.get_input("Give me input pls")

            # Assert
            expect(user_input).to eq(expected_input)
        end

        bad_inputs = ["!", "*"] # plus a lot more examples of bad input
        
        bad_inputs.each do |bad_input|
            xit "raises an exception when input is invalid: '#{bad_input}'" do
                # Arrange
                communicator = described_class.new
                allow(communicator).to receive(:gets).and_return(bad_input)
    
                # Act & Assert
                expect{communicator.get_input("Give me input pls")}.to raise_error(BadInputException)
            end
        end
    end
end