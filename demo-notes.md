# Intro

This project has been developed with the aim of demonstrating various software development principles (mostly relating to SOLID and ATDD). These are notes to aid a demo by pointing out things demonstrated by particular commits.

(NB This is a work in progress so these notes will continue to be added to).

# Principles demonstrated in this code

## Mocks/stubs etc

- See notes on [commit 3fb5382](https://github.com/madetech/academy_2020_mob/commit/3fb5382) below.
- grid_spec: fake_mars_rover
- marsroverapp_spec: stub gets
- marsroverapp_spec: mars_rover_spy, grid_spy, presenter_spy
- marsroverapp_spec: mars_rover_stub, grid_stub, fake_presenter
- presenter_spec: make_real_grid, make_fake_grid

## SOLID 

(my notes on SOLID [are here](https://clare-wiki.herokuapp.com/pages/think/code-princ/SOLID))

### SRP (Single Responsibility Principle) 

- Grid, MarsRover, Presenter, MarsRoverApp.

### OCP (Open/Closed Principle)

- Presenters:
    - injected in app.rb
    - WebPresenter, WideScreenPresenter, SmallScreenPresenter, ColourPresenter
- Rovers:
    - uses a factory, injected to `MarsRoverApp` via app.rb
    - **TODO** FastRover (moves several squares at once)
        - inherits from Rover360 and overrides move
    - Rover360 (original spec, can move in all four directions)
        - inherits from StraightLineRover and adds go_east and go_west
        - also overrides the turn method, to turn 90 degrees instead of 180
    - StraightLineRover (moves in straight lines on a track, so always turns 180 degrees)
        - base rover class
    - FlyingRover (can fly over obstacles unless they are too high)
        - inherits from Rover360 and overrides detect_obstacle

### LSP (Liskov Substitution Principle)

- FlyingRover never encounters obstacles unless they are too high
    - so it throws exceptions from detect_obstacle that are a subclass of the base exception
- Rover360 can return CompassDirection (more restrictive) as a result of its GetDirection, instead of just Direction (covariance with return values)- - Rover360 can take north, east, south or west (less restrictive) as a parameter to the start method, instead of just north or south (contravariance with parameters)

### ISP (Interface Segregation Principle)

- Interfaces:
    - Presenter and grid and communicator:
        - Presenter and grid and communicator might be so tightly coupled that we put them in the same class
        - eg web app
        - but MarsRoverApp doesn't need to know that
- Inheritance:
    - Can't do ISP using inheritance in Ruby, because each class can only inherit from one parent!
    - But we can use interfaces instead of inheritance to implement our Rover classes - see above

### DIP (Dependency Inversion Principle)

- app.rb + MarsRoverApp.initialize(presenter, grid, mars_rover)
- Grid.update(mars_rover)
- Presenter.show_display(grid)
- Mars Rover factory (injected to the app via app.rb)

### OOP

- see SOLID above.

### TPP (Transformation Priority Premise)

- marsrover_spec

### ATDD

- acceptance_tests_spec and marsroverapp_spec
- See [commit bc1767b](https://github.com/madetech/academy_2020_mob/commit/bc1767b) onwards for some outside-in functionality implementation from acceptance test to unit tests (all commits listed below).

### The Factory Pattern

- See `MarsRoverFactory`, injected to `MarsRoverApp` via app.rb

# Commits

## Pseudo code

We started this repo as a group in a couple of mob sessions, deliberately using pseudo code so that we could move quickly and think about how we wanted to proceed at each step. The following commits are all pseudo code. Later on I moved from pseudo code to real code (see below).

- [commit 27b48f8](https://github.com/madetech/academy_2020_mob/commit/27b48f8) - First commit after mob sessions, to simplify things a little.
- [commit c78308d](https://github.com/madetech/academy_2020_mob/commit/c78308d) - First acceptance test for showing the rover in the grid.
- [commit 839e0c0](https://github.com/madetech/academy_2020_mob/commit/839e0c0) - Start implementing grid functionality (might want to skip this and move to the next commit).
- [commit dfc2e78](https://github.com/madetech/academy_2020_mob/commit/dfc2e78) - A few commits later... have now added MarsRover class, Presenter class, main entry point app.rb... all to show the rover in the grid. Note how the different classes have different responsibilities ([SRP](https://clare-wiki.herokuapp.com/pages/think/code-princ/SOLID#s-srp-single-responsibility-principle)).
- [commit 44ba277](https://github.com/madetech/academy_2020_mob/commit/44ba277) - marsroverapp_spec now contains tests showing the use of both test doubles and test spies.
- [commit 860606c](https://github.com/madetech/academy_2020_mob/commit/860606c) - Dependencies were being injected into the start method of MarsRoverApp - now being injected on initialisation ([DIP](https://clare-wiki.herokuapp.com/pages/think/code-princ/SOLID#d-dip-dependency-inversion-principle)).
- [commit 26a2164](https://github.com/madetech/academy_2020_mob/commit/26a2164) - New acceptance test - ask user for input after first initialisation. This can be implemented straight away. Small steps!
- [commit 85b6bef](https://github.com/madetech/academy_2020_mob/commit/85b6bef) - New acceptance test - rover is starting to move. Start implementing in Mars Rover - initially only moving north.
- [commit 2139403](https://github.com/madetech/academy_2020_mob/commit/2139403) - After several commits, the Presenter class and the Mars Rover class are now handling moving forwards in all directions.
- [commit 4254c6f](https://github.com/madetech/academy_2020_mob/commit/4254c6f) - Acceptance and unit tests added for moving backwards.
- [commit c7edd7a](https://github.com/madetech/academy_2020_mob/commit/c7edd7a) - Tests and code added for turning left and right.
- [commit 19c27f1](https://github.com/madetech/academy_2020_mob/commit/19c27f1) - Tests and code added for wrapping around the egde of the grid.
- [commit e1529a5](https://github.com/madetech/academy_2020_mob/commit/e1529a5) - Tests and code added for detecting invalid input.
- [commit b6bfffa](https://github.com/madetech/academy_2020_mob/commit/b6bfffa) - Tests and code for handling repeated inputs.
- [commit 4a7837a](https://github.com/madetech/academy_2020_mob/commit/4a7837a) - Tests and code for handling multiple instructions in one input.
- [commit 5d257a6](https://github.com/madetech/academy_2020_mob/commit/5d257a6) - Obstacle management and more invalid input detection.
- [commit c7e5691](https://github.com/madetech/academy_2020_mob/commit/c7e5691) - Split Presenter into Presenter and Communicator, and create WebPresenter class which implements Presenter, Communicator and Grid interfaces ([ISP](https://clare-wiki.herokuapp.com/pages/think/code-princ/SOLID#i-isp-interface-segregation-principle)) and NarrowScreenPresenter and WideScreenPresenter classes which implement Presenter interface ([OCP](https://clare-wiki.herokuapp.com/pages/think/code-princ/SOLID#o-ocp-open-closed-principle)). 
- [commit 45870ec](https://github.com/madetech/academy_2020_mob/commit/45870ec) - use spies instead of doubles
- [commit 28dc529](https://github.com/madetech/academy_2020_mob/commit/28dc529) - multiple types of rover ([LSP](https://clare-wiki.herokuapp.com/pages/think/code-princ/SOLID#l-lsp-liskov-substitution-principle))
    - Note that there is now a rover factory (factory pattern) to create different types of rover.
    - Note also that the acceptance tests have been significantly changed to take account of multiple rovers, and obstacles when placing new rovers. 
    - See notes above on LSP.

## Real code

- [commit e75628c](https://github.com/madetech/academy_2020_mob/commit/e75628c) - Ignored all tests except one so could start editing the code to make tests runnable. At this point neither the code nor the tests will run, because this is still pseudo code.
- [commit bc1767b](https://github.com/madetech/academy_2020_mob/commit/bc1767b) - At this point various compiler errors have been fixed so the one unignored test will actually run. The next few commits will be listed one at a time because they demonstrate the use of ATDD to address functionality slowly and incrementally from outside in. In this commit the first simple acceptance test (displaying an empty grid) is made to pass by sliming the Presenter class. The app code has been reduced so only this first basic functionality (displaying a grid containing only obstacles) is implemented (although I forgot to edit the test setup, so actually the acceptance test will fail because it will try to show a 5x5 grid instead of the simpler 3x3 grid required by the test).
    - It's worth commenting that this point was arrived at in an unusual way because we started with pseudocode. So by the time we got here we had already "tested" and "implemented" various things such as obstacles, and a display that shows three lines for each cell in the grid. So we're not really at square one in the way we would normally be.
- [commit a0b8b05](https://github.com/madetech/academy_2020_mob/commit/a0b8b05) - Fix some problems with test setup, and move the sliming from the WideScreenPresenter class into a new WideScreenGrid class.
- [commit c9561a8](https://github.com/madetech/academy_2020_mob/commit/c9561a8) - Add a new test case to force SOME of the WideScreenGrid logic (bottom wall of display) to be properly implemented (instead of slimed).
- [commit 1b0d56c](https://github.com/madetech/academy_2020_mob/commit/1b0d56c) - Replaced some more WideScreenGrid sliming with logic.
- [commit 058da24](https://github.com/madetech/academy_2020_mob/commit/058da24) - Refactor: Extract a method (that's the end of this short ATDD demo).
- [commit abde045](https://github.com/madetech/academy_2020_mob/commit/abde045) - Can now display obstacles.
- [commit 743d9e4](https://github.com/madetech/academy_2020_mob/commit/743d9e4) - Can now run from command line and display new rovers of all kinds.
- [commit 3fb5382](https://github.com/madetech/academy_2020_mob/commit/3fb5382) - All previously-pseudo-tests that ought to be passing based on latest actual implemented functionality are now unignored and passing.
    - Note that the tests using doubles and spies are now fixed and working.
    - Note also that the test context "when moving (using test spies)" in `marsroverapp_spec.rb` has an example of how to handle the mocking of deep dependencies, by [stubbing what is returned](https://github.com/madetech/academy_2020_mob/blob/3fb53826252525a52550fdbdb40337da211870e2/mars-rover/spec/marsroverapp_spec.rb#L143) by the `mars_rover_factory`.
- [commit](https://github.com/madetech/academy_2020_mob/commit/)
- [commit ](https://github.com/madetech/academy_2020_mob/commit/)
- [commit ](https://github.com/madetech/academy_2020_mob/commit/)
- [commit ](https://github.com/madetech/academy_2020_mob/commit/)
- [commit ](https://github.com/madetech/academy_2020_mob/commit/)
- [commit ](https://github.com/madetech/academy_2020_mob/commit/)