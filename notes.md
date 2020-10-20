# Demo Notes

For useful commits and notes on what they demonstrate, see separate [demo notes page](demo-notes.md).

# To Implement:

- DO SOME REFACTORING 
- Test that if a movement results in collison with an obstacle then the rover does NOT have its position changed
- Test: Will handle repeated instructions that include new rovers
- Test: Will move the correct rover when there are multiple rovers 
- Test: Will exit when user enters "exit"
- Test: Will ask for new input after detecting an obstacle (just call move_rover_repeatedly)
- To avoid putting two rovers in same spot, put the update function on the rover instead of the grid... and remove the rover from the previous spot before adding it to the new one. Check for obstacles first though!
- Need to add tests / functionality for having a flying rover and an obstacle occupying the same space. At the moment the obstacle is overridden by the flying rover.
- The marsroverapp_spec should test narrow screen too?
- Check the width and height are the right way around in Grid.make_grid for a rectangular grid.
- Should be testing the method params etc? I'm so used to strongly typed languages I expect a lot of things to be caught by the compiler, but that won't happen in Ruby!

# Checking whether output includes specified string

Is this how you do it?

```
# Alright this was an error because I had abort in code I was testing.
# I have made a capture_stderr method to deal with this.

def capture_stderr(&block)
  original_stderr = $stderr.dup
  output_catcher = StringIO.new
  $stderr = output_catcher
  begin
    yield
  rescue SystemExit
  ensure
    $stderr = original_stderr
  end
  output_catcher.string
end

# I am using it like this:

error = capture_stderr('missing_filename.csv')
expect(error).to include('part of error message')
```
From here: https://github.com/rspec/rspec-core/issues/2311

# Displays

WIDE SCREEN MARS ROVER:
-------------------------------
|360^J|     | X X |     | SKY |
|<<<^O|     |  X  |     |  X  |
|MAX^E|     | X X |     | HIGH|
-------------------------------
| SLR |     |360^U|     |360>J|
| ^^^ |     |vvv^M|     |vvv>O|
| JIM |     |MEG^A|     |MIG>N|
-------------------------------
|     |X X>A|     |X XvA|     |
|     | X >M|     | X vN|     |
|     |X X>Y|     |X XvN|     |
-------------------------------
|     | FLY |     |360<B|     |
|     | >>> |     |<<<<O|     |
|     | JAN |     |ENA<B|     |
-------------------------------
|     | X X |     | X X |     |
|     |  X  |     |  X  |     |
|     | X X |     | X X |     |
-------------------------------

(see below for alternative wide screen cell population)


NARROW SCREEN MARS ROVER:
----------------
|  |  |  |  |  |
|  |  |  |  |  |
----------------
|A |  |SK|  |  |
| v|  |HI|  |  |
----------------
|  |XX|  |  | ^|
|  |XX|  |  |B |
----------------
|  |  |  | C|  |
|  |  |  |< |  |
----------------
|  |D |  |  |  |
|  | >|  |  |  |
----------------


WIDE SCREEN - ALTERNATIVE WAYS OF POPULATING CELLS:

-------------------------------
| ^ J |     | | M |     |     |
| | I |     | | E |     |     |
| | M |     | v G |     |     |
-------------------------------
|  ^ J|     |  | M|     |     |
|  | I|     |  | E|     |     |
|  | M|     |  v G|     |     |
-------------------------------
|J  ^ |     |M  | |     |     |
|I  | |     |E  | |     |     |
|M  | |     |G  v |     |     |
-------------------------------
| J ^ |     | M | |     |     |
| I | |     | E | |     |     |
| M | |     | G v |     |     |
-------------------------------
|J ^  |     |M v  |     |     |
|I ^  |     |E v  |     |     |
|M ^  |     |G v  |     |     |
-------------------------------
|J  ^ |     |M  v |     |     |
|I  ^ |     |E  v |     |     |
|M  ^ |     |G  v |     |     |
-------------------------------
|     | JAN |     | ENA |     |
|     | --> |     | <-- |     |
|     |     |     |     |     |
-------------------------------
