class GridConstants
    EMPTY_GRID_WITH_OBSTACLES =
        <<~HEREDOC
        -------------------------------
        |     |     |     |     |     |
        |     |     |     |     |     |
        |     |     |     |     |     |
        -------------------------------
        |     |     |     |     |     |
        |     |     |     |     |     |
        |     |     |     |     |     |
        -------------------------------
        |     |     |     | X X |     |
        |     |     |     |  X  |     |
        |     |     |     | X X |     |
        -------------------------------
        |     |     | SKY |     |     |
        |     |     |  X  |     |     |
        |     |     | HIGH|     |     |
        -------------------------------
        |     |     |     |     |     |
        |     |     |     |     |     |
        |     |     |     |     |     |
        -------------------------------
        HEREDOC

    NEW_ROVER = "ANN,360,0,0,N"    
    GRID_WITH_NEW_ROVER =
        <<~HEREDOC
        -------------------------------
        |     |     |     |     |     |
        |     |     |     |     |     |
        |     |     |     |     |     |
        -------------------------------
        |     |     |     |     |     |
        |     |     |     |     |     |
        |     |     |     |     |     |
        -------------------------------
        |     |     |     | X X |     |
        |     |     |     |  X  |     |
        |     |     |     | X X |     |
        -------------------------------
        |     |     | SKY |     |     |
        |     |     |  X  |     |     |
        |     |     | HIGH|     |     |
        -------------------------------
        |     |     |     |     |     |
        |     |     |     |     |     |
        |     |     |     |     |     |
        -------------------------------
        HEREDOC
end