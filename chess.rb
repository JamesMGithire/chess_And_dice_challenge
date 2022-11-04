class Player
    attr_accessor :points, :color
    attr_reader :name
    def initialize(name)
        @name = name
        @points = 0
        @color = ""
    end
end
puts "Welcome To CLI Chess game"
$colors=["B","W"]
puts "Player 1 name: "
player1_name = gets.chomp
while (player1_name == "")
    puts "Player can't be blank"
    puts "Player 1 name: "
    player1_name = gets.chomp 
end
puts "Player 2 name: "
player2_name = gets.chomp
while (player2_name == player1_name || player2_name == "")
    puts "Player name can't be blank or the same as Player 1"
    puts "Player 2 name: "
    player2_name = gets.chomp 
end
$player1 = Player.new(player1_name)
$player2 = Player.new(player2_name)
puts "#{player1_name} vs #{player2_name}"
puts"Type press Enter for ramdom colors or 'yes' to select colors"
option = gets.chomp

if !option.include?("y") && !option.include?("Y") && option != ""
    puts "Press Enter to select white or input 'black'"
    player1_color = gets.chomp.downcase
    while !($colors.any?{|color|player1_color.include?(color.downcase)})
        puts "colors can only be Black or white"
        player1_color = gets.chomp.downcase
    end
    $player1.color = $colors.find{|color|player1_color.include?(color.downcase)}
    player1_color = $player1.color
else
    $player1.color = $colors.sample
end
$player2.color = $colors.find{|col|col!=$player1.color}
puts "#{$player1.name} : #{$player1.color}"
puts "---------------vs-------------------"
puts "#{$player2.name} : #{$player2.color}"

class Chess
    attr_reader :board
    def all_spots
        arr = (1..8).to_a.reverse
        columns = ('a'..'h').to_a
        arr.collect{|row|columns.collect{|l|"#{l+row.to_s}"}}
    end
    def initialize
        puts "Starting chess game..."
        @board = all_spots
        @board_positions = all_spots
    end
    def move_from_method
        puts "#{@current_color == "W"? "White" : "Black"} move: Move From..."
        puts "(Select board position: example 'd2')"
        @move_from = gets.chomp.downcase
        find_position_validity(@move_from)
    end
    def logic_and_layout
        puts "Chess board layout"
        @board.each{|r|p r}
        puts "---------------------------------------------------"
        puts "Chess board pieces"
        @board[0] = @board[0].collect{|col|col.match(/[ah]/) ? "B"+"♜("+col+")":(col.match(/[bg]/) ? "B"+"♞("+col+")" :(col.match(/[cf]/) ? "B"+"♝("+col+")": col))}
        @board[0][3]="B♛(#{@board[0][3]})"
        @board[0][4]="B♚(#{@board[0][4]})"
        @board[-1] = @board[-1].collect{|col|col.match(/[ah]/) ? "W"+"♜("+col+")":(col.match(/[bg]/) ? "W"+"♞("+col+")" :(col.match(/[cf]/) ? "W"+"♝("+col+")": col))}
        @board[-1][3]="W♛(#{@board[-1][3]})"
        @board[-1][4]="W♚(#{@board[-1][4]})"
        # @board[1] = @board[1].collect{|col|(Pawn.new("B",col)).name}
        # @board[6] = @board[6].collect{|col|(Pawn.new("W",col)).name}
        @board.each{|r|p r}
    end
    def continue_game?(input)
        puts "Press Enter to play or type 'exit' to exit game"
        puts "Continue?>>"
        input = gets.chomp
        input
    end
    def start
        @current_color = "W"
        puts
        def game_options
            puts "<<<<<<<<<<<<<<<< SELECT GAME >>>>>>>>>>>>>>>>>>>"
            puts "a. Random Spot Chess"
            puts "b. Chess"
        end
        game_options
        @game_choice = gets.chomp
        while @game_choice!="a" && @game_choice!="b"
            game_options
            puts "Valid options a or b"
            @game_choice = gets.chomp
        end
        case @game_choice
        when"b"
            logic_and_layout
            loop do
                loop do
                    puts "==================================================="
                    move_from_valid=move_from_method()
                    while(move_from_valid.nil?)
                        puts "ERROR : Position not in board"
                        move_from_valid=move_from_method()
                    end
                    position = @board[$row][$col]
                    while(position.length<6 || !position.include?(@current_color))
                        puts "<< Try another spot >>"
                        puts "--------------------------"
                        position = move_from_method
                    end

                    def piece_moves
                        @possible_moves
                        puts "To..."
                        puts "Possible moves #{@possible_moves}"
                        @move_to = gets.chomp.downcase
                    end
                    
                    puts "To..."
                    @possible_moves = possible_moves_of_piece( position[0], position[1], position[3], position[4])
                    @possible_moves.size!=0 && @move_to = gets.chomp.downcase
                    while(!(find_position_validity(@move_to)) && @possible_moves.size!=0)
                        puts "ERROR : Position not in board"
                        puts "<< You can do better >> "
                        piece_moves
                    end
                    while(!(@possible_moves.any?{|moves|moves==@move_to}) && @possible_moves.size!=0)
                        piece_moves
                    end
                    if @possible_moves.size==0
                        puts "<< Try another piece >>"
                    else
                        break
                    end
                end
                puts "From #{@move_from} to #{@move_to}"
                prev_row = -(@move_from[1]).to_i
                prev_col = @board[prev_row].find_index(@board[prev_row].find{|i|i.include?(@move_from)})
                next_row = -(@move_to[1]).to_i
                next_col = @board[next_row].find_index(@board[next_row].find{|i|i.include?(@move_to)})
                puts "Placed :: #{@board[prev_row][prev_col]} at #{@board_positions[next_row][next_col]}"
                if@board[next_row][next_col].length > 5 
                puts "---------{#{@current_color=="W"? "White": "Black"} takes piece}---------"
                $player1.color== @current_color ? ($player1.points += 1):($player2.points += 1)
                puts "--- <#{$player1.name} : #{$player1.color} : #{$player1.points}> vs <#{$player2.name} : #{$player2.color} : #{$player2.points}> ---"
                end
                @board[next_row][next_col] = "#{@board[prev_row][prev_col].slice(0..1)}(#{@board_positions[next_row][next_col]})"
                @board[prev_row][prev_col] = @board_positions[prev_row][prev_col]
                puts "==================================================="
                @board.each{|r|p r}
                @current_color = @current_color == "W" ? "B" : "W"
                continue = continue_game?(continue)
                puts 
                if(continue.downcase.include?("x") || continue.downcase.include?("q"))
                    break
                end
            end
        else
            exit_input = ""
            current_player = $player1.name
            while !exit_input.include?("q") && !exit_input.include?("x")
                puts
                puts "----------------<[ Current player #{current_player} ]>-----------------"
                piece_name= ["Castle/Rook", "Knight", "Bishop", "Queen", "King"].sample
                pieces = { "Castle/Rook" => "♜", "Knight" => "♞" , "Bishop" => "♝" , "Queen" => "♛" , "King" => "♚" }
                piece = pieces["#{piece_name}"]
                color = current_player == $player1.name ? $player1.color : $player2.color
                rand_position = @board.sample.sample
                puts "#{color == "W"? "White" : "Black"} #{piece_name} at #{rand_position}"
                choice_input = gets.chomp.downcase
                random_piece_possible_moves = possible_moves_of_piece(color,piece,rand_position[0],rand_position[1])
                rand_choice = random_piece_possible_moves.sample
                puts "Possible moves : #{random_piece_possible_moves}"
                choice_input == rand_choice && (current_player == $player1.name ? ($player1.points+=1) : ($player2.points+=1))
                puts  "Computer >> #{rand_choice} ___vs___ #{current_player} >> #{choice_input}"
                puts "#{choice_input} was #{random_piece_possible_moves.include?(choice_input) ? "": "not"} a valid spot."
                puts
                puts "----------------<[ Scores ]>--------------"
                puts "#{$player1.name} has #{$player1.points}"
                puts "-------------------vs----------------------"
                puts "#{$player2.name} has #{$player2.points}"
                puts
                ($player1.points >= 1 || $player2.points >= 1) && break
                exit_input = continue_game?(exit_input)
                current_player = current_player == $player1.name ? $player2.name : $player1.name
            end
        end
    end
    def find_position_validity position
        $row = @board_positions.find_index(@board_positions.find{|i|i.include?(position)})
        $col = $row && @board_positions[$row].find_index(position)
        $row && $col ? (@board[$row][$col]) : nil
    end
    def possible_moves_of_piece(color,piece,current_column,current_row)
        possible_moves = case piece
        when "P"
            color == "W"? Pawn.white_moves(current_column,current_row) : Pawn.black_moves(current_column,current_row)
        when"♜"
            Castle.moves(current_column,current_row,color)
        when"♞"
            Knight.moves(current_column,current_row,color)
        when"♝"
            Bishop.moves(current_column,current_row,color)
        when"♛"
            Queen.moves(current_column,current_row,color)
        when "♚"
            King.moves(current_column,current_row,color)
        end
            @game_choice == "b" && (puts "Possible moves #{possible_moves.compact}")
        !(possible_moves.nil?) ? possible_moves.compact : []
    end
end
# string.split

class Piece
    attr_accessor :position
    attr_reader :name
    def initialize (color,position)
        @color=color
        @position=position
        @name = color+"P("+position+")"
    end

    def self.find_position_validity position
        $new_game.find_position_validity(position)
    end

    def self.shoveler(array, awaiting_position,color)
        oppsite_color = color=="W" ? "B" : "W"
        if awaiting_position.length < 6
            array << awaiting_position
        end
        if awaiting_position.include?(oppsite_color)
            array << "#{awaiting_position[3]}#{awaiting_position[4]}"
        end
    end
    def self.until_breaker(position, inc, on_breake_value)
        if !(position.length < 6)
            inc = on_breake_value
            return true
        end
        false
    end
    #long horizontal_and_vertical movements
    def self.horizontals_and_verticals(current_column,current_row,color)
        possible_moves = []
        move_up_inc = 1
        until (current_row.to_i + move_up_inc) > 8
            new_piece_position = self.find_position_validity("#{current_column}#{(current_row.to_i + move_up_inc)}")
            self.shoveler(possible_moves,new_piece_position,color)
            self.until_breaker(new_piece_position, move_up_inc, 1) ? break : (move_up_inc += 1)
        end
        move_down_inc = 1
        until (current_row.to_i-move_down_inc) < 1
            new_piece_position = self.find_position_validity("#{current_column}#{(current_row.to_i-move_down_inc)}")
            self.shoveler(possible_moves,new_piece_position,color)
            self.until_breaker(new_piece_position, move_down_inc, 0) ? break : (move_down_inc += 1)
        end
        move_left_inc = 1
        until (current_column.ord-move_left_inc).chr == ("a".ord-1).chr
            new_piece_position = self.find_position_validity("#{(current_column.ord-move_left_inc).chr}#{(current_row.to_i)}")
            self.shoveler(possible_moves,new_piece_position,color)
            self.until_breaker(new_piece_position, move_left_inc, 1) ? break : (move_left_inc += 1)
        end
        move_right_inc = 1
        until (current_column.ord+ move_right_inc).chr == ("h".ord+1).chr
            new_piece_position = self.find_position_validity("#{(current_column.ord+move_right_inc).chr}#{(current_row.to_i)}")
            self.shoveler(possible_moves,new_piece_position,color)
            self.until_breaker(new_piece_position, move_right_inc, 1) ? break : (move_right_inc += 1)
        end
        possible_moves
    end
    # long diagonals
    def self.diagonls(current_column,current_row,color)
        possible_moves = []
        left_up_inc = 1
        until self.find_position_validity("#{(current_column.ord-left_up_inc).chr}#{(current_row.to_i+left_up_inc)}").nil?
            new_piece_position = self.find_position_validity("#{(current_column.ord-left_up_inc).chr}#{(current_row.to_i+left_up_inc)}")
            self.shoveler(possible_moves,new_piece_position,color)
            self.until_breaker(new_piece_position, left_up_inc, 1) ? break : (left_up_inc += 1)
        end
        right_up_inc = 1
        until self.find_position_validity("#{(current_column.ord+right_up_inc).chr}#{(current_row.to_i+right_up_inc)}").nil?
            new_piece_position = self.find_position_validity("#{(current_column.ord+right_up_inc).chr}#{(current_row.to_i+right_up_inc)}")
            self.shoveler(possible_moves,new_piece_position,color)
            self.until_breaker(new_piece_position, right_up_inc, 1) ? break : (right_up_inc += 1)
        end
        left_down_inc = 1
        until self.find_position_validity("#{(current_column.ord-left_down_inc).chr}#{(current_row.to_i-left_down_inc)}").nil?
            new_piece_position = self.find_position_validity("#{(current_column.ord-left_down_inc).chr}#{(current_row.to_i-left_down_inc)}")
            self.shoveler(possible_moves,new_piece_position,color)
            self.until_breaker(new_piece_position, left_down_inc, 1) ? break : (left_down_inc += 1)
        end
        right_down_inc = 1
        until self.find_position_validity("#{(current_column.ord+right_down_inc).chr}#{(current_row.to_i-right_down_inc)}").nil?
            new_piece_position = self.find_position_validity("#{(current_column.ord+right_down_inc).chr}#{(current_row.to_i-right_down_inc)}")
            self.shoveler(possible_moves,new_piece_position,color)
            self.until_breaker(new_piece_position, right_down_inc, 1) ? break : (right_down_inc += 1)
        end
        possible_moves
    end
end

class Pawn < Piece
    attr_accessor :position
    attr_reader :name
    def self.pawn_diagonal_capture_shoveler(array,position,color)
        oppsite_color = color == "W" ? "B" : "W"
        unless position.nil?
            if position.include?(oppsite_color)
                array << "#{position[3]}#{position[4]}"
            end
        end
    end
    def self.white_move_forward?(current_column,current_row)
        possible_moves = []
        if(($new_game.board[7-(current_row.to_i)].find{|spot|spot.include?(current_column)}.length) < 6)
            possible_moves << "#{current_column}#{(current_row.to_i)+1}"
            if(current_row=="2" && self.find_position_validity("#{current_column}#{(current_row.to_i)+2}").length < 6)
                possible_moves << "#{current_column}#{(current_row.to_i)+2}"
            end
        end
        possible_moves
    end
    def self.white_take_black?(current_column,current_row)
        white_take_possible_moves = []
        white_take_position_plus = self.find_position_validity("#{(current_column.ord+1).chr}#{(current_row.to_i)+1}")
        white_take_position_minus =  self.find_position_validity("#{(current_column.ord-1).chr}#{(current_row.to_i)+1}")
        self.pawn_diagonal_capture_shoveler(white_take_possible_moves, white_take_position_plus,"W")
        self.pawn_diagonal_capture_shoveler(white_take_possible_moves, white_take_position_minus,"W")
        white_take_possible_moves
    end
    def self.black_move_forward?(current_column,current_row)
        possible_moves = []
        black_pawn_possible_position = self.find_position_validity("#{current_column}#{(current_row.to_i)-1}")
        unless black_pawn_possible_position.nil?
            if(black_pawn_possible_position.length < 6)
                possible_moves << black_pawn_possible_position
                if(current_row=="7" && self.find_position_validity("#{current_column}#{(current_row.to_i)-2}").length < 6)
                    possible_moves << "#{current_column}#{(current_row.to_i)-2}"
                end
            end
        end
        possible_moves
    end
    def self.black_take_white?(current_column,current_row)
        black_take_possible_moves = []
        black_take_position_plus = self.find_position_validity("#{(current_column.ord+1).chr}#{(current_row.to_i)-1}")
        black_take_position_minus = self.find_position_validity("#{(current_column.ord-1).chr}#{(current_row.to_i)-1}")
        self.pawn_diagonal_capture_shoveler(black_take_possible_moves, black_take_position_plus,"B")
        self.pawn_diagonal_capture_shoveler(black_take_possible_moves, black_take_position_minus,"B")
        black_take_possible_moves
    end
    def self.black_moves(current_column,current_row)
        [
            self.black_move_forward?(current_column,current_row),
            self.black_take_white?(current_column,current_row)
        ].flatten
    end
    def self.white_moves(current_column,current_row)
        [self.white_move_forward?(current_column,current_row),
        self.white_take_black?(current_column,current_row)
        ].flatten
    end
end

class Castle<Piece
    def initialize(color, position)
        super(color, position)
    end
    def self.moves(current_column,current_row,color)
        self.horizontals_and_verticals(current_column,current_row,color)
    end
end

class Knight < Piece
    def self.knight_shoveler(array_checked,color)
        array_shoveled = []
        knight_oppsite_color = color == "W" ? "B" : "W"
        array_checked.map do |spot|
            position = self.find_position_validity(spot)
            unless position.nil?
                if position.length < 6
                    self.shoveler(array_shoveled,position,knight_oppsite_color)
                end
                if position.include?(knight_oppsite_color)
                    array_shoveled << "#{position[3]}#{position[4]}"
                end
            end
        end
        array_shoveled
    end
    
    def self.moves(current_column,current_row,color)
        knight_possible_spots = [
            "#{(current_column.ord+1).chr}#{current_row.to_i+2}",# up
            "#{(current_column.ord-1).chr}#{current_row.to_i+2}",
            "#{(current_column.ord+1).chr}#{current_row.to_i-2}",# down
            "#{(current_column.ord-1).chr}#{current_row.to_i-2}",
            "#{(current_column.ord-2).chr}#{current_row.to_i-1}",#left
            "#{(current_column.ord-2).chr}#{current_row.to_i+1}",
            "#{(current_column.ord+2).chr}#{current_row.to_i-1}",#right
            "#{(current_column.ord+2).chr}#{current_row.to_i+1}"
         ]
        self.knight_shoveler(knight_possible_spots,color).flatten.uniq
    end
end
class Bishop < Piece
    def self.moves(current_column,current_row,color)
        self.diagonls(current_column,current_row,color)
    end
end
class Queen < Piece
    def self.moves(current_column,current_row,color)
        [
            self.diagonls(current_column,current_row,color),
            self.horizontals_and_verticals(current_column,current_row,color)
        ].flatten.uniq
    end
end
class King < Piece
    def self.moves(current_column,current_row,color)
        king_possible_moves = []
        king_oppsite_color = color == "W" ? "B" : "W"
        for i in -1..1 do i
            for j in -1..1 do j
                new_king_position = self.find_position_validity("#{(current_column.ord+j).chr}#{current_row.to_i+i}")
                unless new_king_position.nil? 
                    if new_king_position.length < 6 || new_king_position.include?(king_oppsite_color)
                        king_possible_moves << "#{(current_column.ord+j).chr}#{current_row.to_i+i}"
                    end
                end
            end    
        end
        king_possible_moves
    end
end
$new_game = Chess.new
$new_game.start