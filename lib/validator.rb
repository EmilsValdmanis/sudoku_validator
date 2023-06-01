class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    # All the error checks
    return 'Sudoku is invalid.' if validate_characters?
    return 'Sudoku is invalid.' if has_duplicates? # keep the default flag
    return 'Sudoku is invalid.' if has_duplicates?("column") # pass the "column flag to transpose before checking"
    return 'Sudoku is invalid.' if has_group_duplicates?

    # Check if sudoku is complete or not
    if has_zeros?
      'Sudoku is valid but incomplete.'
    else
      'Sudoku is valid.'
    end
  end

  private

  def parse_grid
    # 1. We start by splitting the string into rows by splitting over the newline character
    # 2. Then we get rid of (reject) lines that start with '-' by iterating over them]
    # 3. We iterate over the remaining rows and split them over " | " which is the vertical line of the sudoku string
    # 4. Then we iterate over each cell (3x1) and split them over whitespaces "\s" or "|" to get individual values
    # 5. We convert the individual values to integers
    # 6. Flatten the array to get rid of nested array
    @puzzle_string.split("\n").reject { |row| row.start_with?("-") }.map do |row|
      row.split(" | ").map do |cell|
        cell.split(/[\s\|]+/).map(&:to_i)
      end.flatten
    end
  end

  def validate_characters?
    # 1. Flatten to put all characters in a single 1D array 
    # 2. Check if any of those characters is either a string or not within the allowed value of 0-9
    # Returns true if there are any invalid characters and returns false when all is good
    parse_grid.flatten.any? { |num| !num.is_a?(Integer) || num < 0 || num > 9 }
  end

  def has_duplicates?(check_type = "row")
  # Transpose the grid if check_type is "column" to convert columns into rows
  grid = (check_type == "column") ? parse_grid.transpose : parse_grid

  # Iterate over each row (or "column")
  grid.each do |row|
    non_zeros = row.reject(&:zero?) # remove zeroes
    # Simply check if there is a length difference between the original array without any zeroes and the array with removed duplicates using ".uniq"
    # If there is a difference there must be a in the row/column
    return true if non_zeros.uniq.length != non_zeros.length
  end
  false
end

  def has_group_duplicates?
    # We start by slicing the grid into 3x9 pieces (3 rows per group)
    parse_grid.each_slice(3) do |rows|
      # We transpose those rows to make the columns into rows and again slice them into groups of 3 rows, essentially giving us 3x3 chunks of our grid
      rows.transpose.each_slice(3) do |group| # we iterate over each 3x3 group
        values = group.flatten.reject(&:zero?) # we flatten and ignore zeroes
        return true if values.uniq.length != values.length # use the same technique (like in has_duplicates?) to check if there are any group duplicates
      end
    end
    false # if there are no duplicates return true
  end

  def has_zeros?
    # Simply flatten the array and check if it includes any zeroes
    parse_grid.flatten.include?(0)
  end
end
