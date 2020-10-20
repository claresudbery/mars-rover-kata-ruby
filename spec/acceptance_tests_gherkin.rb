Given "the user hasn't started the program yet"
When "the user starts the program"
Then "an empty 5*5 grid appears"
And "the grid shows existing obstacles"
And "the grid shows existing sky-high obstacles"
And "the user is prompted for coordinates, direction, name and type of the first rover"

Given "the user has started the program"
When "the user inputs invalid coordinates, direction, name or type"
Then "the user is shown an error"

Given "the user has started the program"
When "the user asks to create a straight-line Rover facing East or West"
Then "the user is shown an error"

Given "the user has started the program"
When "the user inputs coordinates that conflict with an obstacle"
Then "the user is shown an error"

Given "the user has started the program"
When "the user inputs coordinates for a flying rover that conflict with a sky-high obstacle"
Then "the user is shown an error"

Given "the user has started the program"
When "the user inputs the coordinates, direction, name and type of the first rover"
Then "the display is updated with the position of the rover"
And "the display is updated with the direction of the rover"
And "the display is updated with the name of the rover"
And "the display is updated with the type of the rover"
And "the user is prompted to input movement or direction for the existing rover, or create a new rover"

Given "the user has input the coordinates and direction of the first rover"
When "the user gives an invalid further instruction"
Then "the user is shown an error"

Given "the user has input the coordinates and direction for a specified rover"
When "the user tells that rover to move forwards"
Then "the display is updated with that rover advanced one square in the direction it is facing"

Given "the user has input the coordinates and direction for a specified rover"
When "the user tells that rover to move backwards"
Then "the display is updated with that rover moving one square in the opposite direction to that which it faces"

Given "the user has input the name, coordinates and direction for a rover 360 or a flying rover"
When "the user tells that rover to turn left"
Then "the display is updated with that rover facing a direction 90 degrees anticlockwise from before"

Given "the user has input the name, coordinates and direction for a rover 360 or a flying rover"
When "the user tells that rover to turn right"
Then "the display is updated with that rover facing a direction 90 degrees clockwise from before"

Given "the user has input the name, coordinates and direction for a straight-line rover"
When "the user tells that rover to turn left"
Then "the display is updated with that rover facing in the opposite direction"

Given "the user has input the name, coordinates and direction for a straight-line rover"
When "the user tells that rover to turn right"
Then "the display is updated with that rover facing in the opposite direction"

Given "the user has input coordinates and direction placing a specified rover facing the edge of the grid"
When "the user tells that rover to move forwards"
Then "the display is updated with that rover having 'wrapped' around to the other side of the grid"

Given "the user has input coordinates and direction for the first rover"
When "the display has updated"
Then "the user can keep inputting repeated movements and turns"
And "the display will update in response to every input"

Given "the user has input coordinates and direction for the first rover"
When "the display has updated"
Then "the user can input several movements and turns for a specified rover in one input"
And "the display will update in response to every movement and turn in the input"

Given "the user has input coordinates and direction placing a non-flying rover facing an obstacle"
When "the user tells that rover to move forwards"
Then "an error will inform the user that there is an obstacle in the way"

Given "the user has input coordinates and direction placing a non-flying rover with its back to an obstacle"
When "the user tells that rover to move backwards"
Then "an error will inform the user that there is an obstacle in the way"

Given "the user has input coordinates and direction placing a flying rover facing a sky-high obstacle"
When "the user tells that rover to move forwards"
Then "an error will inform the user that there is an obstacle in the way"

Given "the user has input coordinates and direction placing a flying rover with its back to a sky-high obstacle"
When "the user tells that rover to move backwards"
Then "an error will inform the user that there is an obstacle in the way"

Given "the user has input coordinates and direction for the first rover"
When "the user asks for a new rover to be created - giving coordinates, direction, name and type"
Then "the display is updated with the position of the new rover"
And "the display is updated with the direction of the new rover"
And "the display is updated with the name of the new rover"
And "the display is updated with the type of the new rover"
And "the user is prompted to input movement or direction for an existing rover, or create a new rover"

Given "the user has input coordinates and direction for the first rover"
When "the user asks to create a new straight-line Rover facing East or West"
Then "the user is shown an error"

Given "the user has input coordinates and direction for some rovers already"
When "the user asks for a new rover to be created - giving coordinates, direction, name and type"
And "the coordinates conflict with an obstacle or another rover"
Then "the user is shown an error"

Given "the user has input coordinates and direction for some rovers already"
When "the user asks for a new flying rover to be created - giving coordinates, direction, name and type"
And "the coordinates conflict with a sky-high obstacle"
Then "the user is shown an error"


