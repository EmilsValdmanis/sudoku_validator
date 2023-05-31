class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    return 'Sudoku is invalid.' if validate_characters?
    return 'Sudoku is invalid.' if has_row_duplicates?
    return 'Sudoku is invalid.' if has_column_duplicates?
    return 'Sudoku is invalid.' if has_group_duplicates?

    if has_zeros?
      'Sudoku is valid but incomplete.'
    else
      'Sudoku is valid.'
    end
  end

  private

  def parse_grid
    @puzzle_string.split("\n").reject { |row| row.start_with?("-") }.map do |row|
      row.split(" | ").map do |cell|
        cell.split(/[\s\|]+/).reject { |num| num.empty? || num == "-" }.map(&:to_i)
      end.flatten
    end
  end

  def validate_characters?
    parse_grid.flatten.any? { |num| !num.is_a?(Integer) || num < 0 || num > 9 }
  end

  def has_row_duplicates?
    parse_grid.each do |row|
      non_zeros = row.reject(&:zero?)
      return true if non_zeros.uniq.length != non_zeros.length
    end
    false
  end

  def has_column_duplicates?
    grid = parse_grid
    grid.transpose.each do |column|
      non_zeros = column.reject(&:zero?)
      return true if non_zeros.uniq.length != non_zeros.length
    end
    false
  end

  def has_group_duplicates?
    parse_grid.each_slice(3) do |rows|
      rows.transpose.each_slice(3) do |group|
        values = group.flatten.reject(&:zero?)
        return true if values.uniq.length != values.length
      end
    end
    false
  end

  def has_zeros?
    parse_grid.flatten.include?(0)
  end
end
