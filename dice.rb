class Player
    attr_accessor :score
    def initialize
        @score = 0
    end
    def roll
        (1..6).to_a.sample
    end
end
ply1 = Player.new
ply2 = Player.new
$exit = ""

until (ply1.score>=100 && ply2.score>=100)
    # puts
    pl1_roll = ply1.roll
    puts "Player 1 prev score #{ply1.score}"
    pl1_roll==1? (ply1.score=0) : (ply1.score += pl1_roll)
    puts "Player 1 rolled #{pl1_roll}"
    puts "player 1 new Score >> #{ply1.score}"
    gets
    pl2_roll = ply2.roll
    puts "Player 2 prev score #{ply2.score}"
    pl2_roll==1? (ply2.score=0) : (ply2.score += pl2_roll)
    puts "Player 2 rolled #{pl2_roll}"
    puts "player 2 new Score >> #{ply2.score}"
    $exit = gets
end