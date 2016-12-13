# 00 01 02
# 10 11 12
# 20 21 22

# 4 / 9 / 3 -> 1
# 4 % 9 / 3 -> 1

# We iterate through the string stopping at each time we find '-'
# At these 'empty' spaces we check the superbox, row, and column
# We compare it with a range of numbers from 1 to 9, to see the possible entries?

# 

# 0  1  2  3  4  5  6  7  8
# 9  10 11 12 13 14 15 16 17
# 18 19 20 21 22 23 24 25 26

def row(board, cell)
  nums = []

  cell -= 1 until cell % 9 == 0

  (cell..cell+8).each do |row_cell|
    val = board[row_cell]
    nums << val if val != '-'
  end

  nums
end

def col(board, cell)
  nums = []

  cell -= 9 until cell / 9 == 0

  (cell..80).step(9).each do |col_cell| # gets all the indices of a cell's column
    val = board[col_cell]
    nums << val if val != '-'
  end
  
  nums
end

def box(board, cell)
  populate_box(board)["#{ cell / 9 / 3 }#{ cell % 9 / 3 }"]
end

def populate_box(board)
  box = { '00' => [], # stores an array of the values within each of the 9, 3x3 blocks
          '01' => [],
          '02' => [],
          '10' => [],
          '11' => [],
          '12' => [],
          '20' => [],
          '21' => [],
          '22' => [] }

  board.each_char.with_index do |num, index|
    unless num == '-'
      box["#{ index / 9 / 3 }#{ index % 9 / 3 }"] << num
    end
  end

  box
end

def unused_nums(board, cell)
  # make an array from 1..9, and subtract the union of row+col+box
  nums = Array(1..9)
  # puts "row: #{row(board, cell)}"
  # puts "col: #{col(board, cell)}"
  # puts "box: #{box(board, cell)}"
  nums.map(&:to_s) - (row(board, cell) | col(board, cell) | box(board, cell))
end


def update(board, poss)
  board.each_char.with_index do |cell, i|
    poss[i] = unused_nums(board, i).length.to_s if cell == "-"
  end
end



def solve(board)
  poss = " " * 81
  update(board, poss)
  # puts poss
  return board unless board.include?('-')
  # if there is a 1 in the poss string, fill in the appropriate index in board with the only possible value
  # call solve on this new board
  # puts poss
  poss.each_char.with_index do |char, i|
    if char == "1"
      board[i] = unused_nums(board, i)[0]
    end
  end
  solve(board)
end

def print_board(board)
  board.split('').each_slice(9).to_a.each do |t|
    puts t.join(' ')
  end
end

sudoku = ["1-58-2----9--764-52--4--819-19--73-6762-83-9-----61-5---76---3-43--2-5-16--3-89--",
"--5-3--819-285--6-6----4-5---74-283-34976---5--83--49-15--87--2-9----6---26-495-3",
"29-5----77-----4----4738-129-2--3-648---5--7-5---672--3-9--4--5----8-7---87--51-9",
"-8--2-----4-5--32--2-3-9-466---9---4---64-5-1134-5-7--36---4--24-723-6-----7--45-",
"6-873----2-----46-----6482--8---57-19--618--4-31----8-86-2---39-5----1--1--4562--",
"---6891--8------2915------84-3----5-2----5----9-24-8-1-847--91-5------6--6-41----",
"-3-5--8-45-42---1---8--9---79-8-61-3-----54---5------78-----7-2---7-46--61-3--5--",
"-96-4---11---6---45-481-39---795--43-3--8----4-5-23-18-1-63--59-59-7-83---359---7",
"----754----------8-8-19----3----1-6--------34----6817-2-4---6-39------2-53-2-----",
"3---------5-7-3--8----28-7-7------43-----------39-41-54--3--8--1---4----968---2--",
"3-26-9--55--73----------9-----94----------1-9----57-6---85----6--------3-19-82-4-",
"-2-5----48-5--------48-9-2------5-73-9-----6-25-9------3-6-18--------4-71----4-9-",
"--7--8------2---6-65--79----7----3-5-83---67-2-1----8----71--38-2---5------4--2--",
"----------2-65-------18--4--9----6-4-3---57-------------------73------9----------"]


sudoku.each do |board_string|
  puts "Initial board"
  print_board(board_string)
  puts "Solved board"
  print_board(solve(board_string))
end