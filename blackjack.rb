class Array
  def sample!
    delete_at rand length
  end
end

def initialize_deck(deck)
  (1..13).each do |num|
    # 1: spades 2: hearts 3: diamonds 4: clubs
    (1..4).each do |suit|
      deck << {num: num, suit: suit, val: num < 10 ? num : 10}
    end
  end
  deck
end

def get_card(deck)
  deck.sample!
end

def card_name(card)
  # Set the suit name
  case card[:suit]
  when 1
    suit_name = 'Spades'
  when 2
    suit_name = 'Hearts'
  when 3
    suit_name = 'Diamonds'
  when 4
    suit_name = 'Clubs'
  end

  # Set the card name
  case
  when card[:num] == 1
    card_name = 'Ace'
  when card[:num] <= 10
    card_name = card[:num].to_s
  when card[:num] == 11
    card_name = 'Jack'
  when card[:num] == 12
    card_name = 'Queen'
  when card[:num] == 13
    card_name = 'King'        
  end

  card_name + ' of ' + suit_name
end

def show_cards(name, hand, hide_second_card = false)
  print "#{name} cards: " 
  hand.each_with_index do |card, i|
    if i == 0 && hide_second_card
      print 'XXXXXXXXXXX'
    else
      print card_name(card)
    end

    print ', ' if i < hand.size - 1
  end

  puts "\n\n"
end

def show_table(user_hand, dealer_hand, hide_dealer = true)
  system 'clear' or system 'cls'
  show_cards("Dealer", dealer_hand, hide_dealer)
  show_cards("User", user_hand)
end

def get_total(hand)
  sum = 0
  hand.each {|card| sum += card[:val]}
  sum
end


def has_ace?(hand)
  hand.each {|card| return true if card[:num] == 1}
  false
end

def decide_dealer_action(hand)
  dealer_total = get_total(hand)

  # Aces are always counted as 11 if possible
  # without the dealer going over 21
  if has_ace?(hand) && dealer_total <= 11
    dealer_total += 10
  end

  return 'h' if dealer_total < 17 # hit

  's' # stand
end

# Start of the program flow

deck = []
initialize_deck(deck)

dealer = []
user = []

user << get_card(deck)
dealer << get_card(deck)
user << get_card(deck)
dealer << get_card(deck)

if get_total(user) == 21 && get_total(dealer) == 21
  puts "Tie."
  exit
end

while true
  show_table(user, dealer)
  user_total = get_total(user)

  if user_total == 21
    puts "Blackjack, you won!"
    exit
  elsif user_total > 21
    puts "You are busted, dealer won."
    exit
  end

  puts "(H)it or (S)tand?"
  user_action = gets.chomp.downcase

  if user_action == 'h'
    user << get_card(deck)
  else
    break
  end
end

while true
  dealer_total = get_total(dealer)

  if dealer_total == 21
    puts "Blackjack, dealer won!"
    exit
  elsif dealer_total > 21
    puts "You are busted, dealer won."
    exit
  end

  dealer_action = decide_dealer_action(dealer)

  if dealer_action == 'h'
    dealer << get_card(deck)
  else
    show_table(user, dealer, false)

    if user_total == dealer_total
      puts "Tie."
    elsif user_total > dealer_total
      puts "You won!"
    else
      puts "Dealer won."
    end
    exit
  end
end