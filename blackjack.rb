# build blackjack card game
# Shuffle a deck of cards
# Display it
# Assign values to the cards, could have some values
# Assign names to the cards
# Display them
# give player a bankroll
# set table limits $5 to $500
# start game
# dealer deals cards to player, himself, player, himself.  his other card
    # is "x" out until the end
# the player chooses either hit me or stay
# the player either wins or loses that hand
# the money gets either added or subtracted from their bankroll
# take ascii symbols for 'spades', 'hearts', 'clubs' and 'diamonds' and insert
  # them into a card shape along with the value so it visually looks good

# pry is a cool gem that allows you to have a REPL (read, evaluate, print, loop)
# require 'pry' 

@deck = []
@dealer_hand = []
@dealer_2nd_card = "" # this card is face down showing 'X' in the array and replaced at the end when it is dealers turn
@player_hand = []
@dealer_hand_total = 0
@player_hand_total = 0
@game_over = false
@player_bank_roll = 1000
@table_limits = [5, 500] # $5 minimum to $500 maximum
@player_bet = 0
@dealer_turn = false # this shows 2 cards one face up and one hidden
                      # when true the hidden card is shown and hit or stay

def create_deck(suit)
  deck = [2, 3, 4, 5, 6, 7, 8, 9, 10, "King", "Jack", "Queen", "Ace"]
  deck.each do |card|
    @deck << "#{suit}_#{card}"
  end
end
create_deck("spades")
create_deck("diamonds")
create_deck("clubs")
create_deck("hearts")

@deck.shuffle!

def deal_card(player)
  dealt_card = @deck.pop
  
  if player == 'dealer'
    @dealer_hand << dealt_card
  elsif player == 'player'
    @player_hand << dealt_card
  end
  nil
end

def display(player) 
  if player == "dealer"
    puts "DEALER HAND"
    construct_card_display(player, @dealer_hand, @dealer_hand.size)
  end
  if player == "player"
    puts "PLAYER HAND"
    construct_card_display(player, @player_hand, @player_hand.size)
  end
end

def construct_card_display(player, player_hand, number_of_cards)
  # you also need the players hand and number of cards
    #convert everything
  value = {"Ace" => "A", "Jack" => "J", "King" => "K", "Queen" => "Q", 
            "1" => "1", "2" => "2", "3" => "3", "4" => "4", "5" => "5",
            "6" => "6", "7" => "7", "8" => "8", "9" => "9", "10" => "10"}
            
  suit = {"diamonds" => '♦', "hearts" => '♥', "clubs" => '♣', "spades" => '♠'}
  s = 0
  v = 0
  
  # this holds the 's' and 'v' in the form 's_v' in an array
  # this allows me to break it apart later below for display purposes
  @card_details = []
  
    player_hand.each do |card|
      card = card.split('_')
      s = suit[card[0]]  #suit
      v = value[card[1]] #value
      if v != "10"
        v = "#{value[card[1]]} " # adding an extra space for display
      end
      @card_details << "#{s}_#{v}"
    end

  # This is my way of displaying the cards horizontally
  # it is somewhat cryptic but it works
  # basically it prints the top sides and edges of the cards 
  # as well as putting in the 'suit' and 'value'
  # it displays then in the terminal horizontally which is harder to do
  
  if (player == "dealer" && !@dealer_turn && number_of_cards > 1)
    # show first card and hidden card
    print "┌─────────┐┌─────────┐"
    puts ""
    print "│#{v}       ││░░░░░░░░░│"
    puts ""
    print "│         ││░░░░░░░░░│"
    puts ""
    print "│         ││░░░░░░░░░│"
    puts ""
    print "│    #{s}    ││░░░░░░░░░│"
    puts ""
    print "│         ││░░░░░░░░░│"
    puts ""
    print "│         ││░░░░░░░░░│"
    puts ""
    print "│       #{v}││░░░░░░░░░│"
    puts ""
    print "└─────────┘└─────────┘"
    puts ""
    
  else
    number_of_cards.times { print "┌─────────┐" } 
    puts ""
    number_of_cards.times do |i|
      card = @card_details[i].split('_')
      # index 1 is the value
      v = card[1] 
      print "│#{v}       │"
    end
    puts ""
    number_of_cards.times { print "│         │" }
    puts ""
    number_of_cards.times { print "│         │" }
    puts ""
    number_of_cards.times do |i|
      card = @card_details[i].split('_')
      # index 0 suit
      s = card[0] 
      print "│    #{s}    │" 
    end
    puts ""
    number_of_cards.times { print "│         │" }
    puts ""
    number_of_cards.times { print "│         │" }
    puts ""
    number_of_cards.times do |i|
      card = @card_details[i].split('_')
      v = card[1]
      print "│       #{v}│" 
    end
    puts ""
    number_of_cards.times { print "└─────────┘" }
    puts ""
  end
end

def hidden_card
  puts  "┌─────────┐"
  puts  "│░░░░░░░░░│"
  puts  "│░░░░░░░░░│"
  puts  "│░░░░░░░░░│"
  puts  "│░░░░░░░░░│"
  puts  "│░░░░░░░░░│"
  puts  "│░░░░░░░░░│"
  puts  "│░░░░░░░░░│"
  puts  "└─────────┘"
  
end

def get_hand_total(player_hand)

  player_hand_total = 0
  aces_in_hand = 0
  get_card_values = {"Ace" => 11, "Other" => 10} 
  
  # iterate over player
  # add up all the cards
  # keep track of aces in hand
  # then while total > 21, subtract out 10 for each Ace
  
  player_hand.each do |card|
    card = card.split('_') # 0 element is suit.  1 element is hand value
    if card[1] == "Ace"
      player_hand_total += get_card_values["Ace"]
      aces_in_hand += 1
    elsif card[1] == "Jack" || 
          card[1] == "Queen" || 
          card[1] == "King"
      player_hand_total += get_card_values["Other"]
    else
      player_hand_total += card[1].to_i
    end
  end
  while aces_in_hand > 0 # while we have Aces
    # and we are busted over 21...
    # then instead of counting as 11, count as 1
    # we do this by subtracting 10 for each Ace until we are <= 21
    if player_hand_total > 21
      player_hand_total -= 10
    end
    aces_in_hand -= 1 # then we decrement the aces_in_hand
  end
  player_hand_total # return this
end 


def play_game
  place_bet
  initial_deal
  player_turn
  puts "game over"
end

def player_turn
  while !@dealer_turn && !@game_over
    puts "it is the players turn"
    puts "Your total card count is #{get_hand_total(@player_hand)}"
    puts "Hit me or stay? (h for hit me.  any other key to stay)"
    choice = gets.chomp.downcase
    if choice == 'h'
      deal_card("player")
      display("player")
    else
      puts "You chose to Stay.  Dealers turn"
      display("player")
      @dealer_turn = true
    end
    if bust?(@player_hand)
      puts "Your count is #{get_hand_total(@player_hand)}"
      puts "You lose. "
      puts winner?
      puts "you lost #{@player_bet}.  Your bankroll is #{@player_bank_roll}"
      @game_over = true
      @dealer_turn = true
    end
  end
  while @dealer_turn && !@game_over
    puts "its the dealers turn"
    puts "your total card count is #{get_hand_total(@dealer_hand)}"
    puts "Hit me or stay? (h for hit me.  any other key to stay)"
    choice = gets.chomp.downcase
    if choice == 'h'
      deal_card("dealer")
      display("dealer")
    else
      puts "You chose to Stay.  Let's see who wins! "
      display("dealer")
      puts winner?
      @dealer_turn = false
      @game_over = true
    end
    if bust?(@dealer_hand)
      puts "Your count is #{get_hand_total(@dealer_hand)}"
      puts "You lose. "
      puts winner?
      @dealer_turn = true
      @game_over = true
    end
  end
end
def winner?
    return "Player Wins" if get_hand_total(@player_hand) > get_hand_total(@dealer_hand) && 
                            !bust?(@player_hand) || bust?(@dealer_hand)
    return "Dealer Wins" if get_hand_total(@dealer_hand) > get_hand_total(@player_hand) && 
                            !bust?(@dealer_hand) || bust?(@player_hand)
    return "Draw" if get_hand_total(@dealer_hand) == get_hand_total(@player_hand) 
end

def bust?(player_hand)
  hand_total = get_hand_total(player_hand)
  return true if hand_total > 21
  false
end

def initial_deal
  4.times do |i|
    # 0 is for player which is ODD
    # 1 is for dealer which is EVEN
    if i % 2 == 0 
      deal_card("player")
      display("player")
    elsif i % 2 != 0
      deal_card("dealer")
      display("dealer")
    end
  end
end

def place_bet
    puts "Please Place your bet from $#{@table_limits[0]} to $#{@table_limits[1]}"
  begin
    @player_bet = gets.chomp
    @player_bet = Integer(@player_bet)
    @player_bank_roll -= @player_bet
    puts "You're bet is $#{@player_bet}.  Your bankroll is now $#{@player_bank_roll}"
  rescue 
    puts "Invalid entry.  Integers only"
  ensure
  end
end

play_game


# binding.pry

