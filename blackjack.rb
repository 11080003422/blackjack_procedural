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

def show_cards(user_hand, dealer_hand, hide_dealer = true)
  system 'clear' or system 'cls'
  print 'Dealer cards: '
  dealer_hand.each_with_index do |card, i|
    if i == 0 && hide_dealer
      print 'XXXXXXXXXXX'
    else
      print card_name(card)
    end

    print ', ' if i < dealer_hand.size - 1
  end

  puts "\n\n"

  print 'User cards: '
  user_hand.each_with_index do |card, i|
    print card_name(card)
    print ', ' if i < user_hand.size - 1
  end

  puts "\n\n"
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

def get_result(user_hand, dealer_hand)
  user_total = get_total(user_hand)
  dealer_total = get_total(dealer_hand)

  # Check for tie
  if (user_total == dealer_total)
    return 0 # tie
  end

  # Check for blackjack
  if user_total == 11 && has_ace?(user_hand)
    return 1 if user_hand.count == 2 # user blackjack
    return 7
  elsif dealer_total == 11 && has_ace?(dealer_hand)
    return 2 if dealer_hand.count == 2 # dealer blackjack
    return 8
  end

  # Check for bust    
  if (user_total > 21)
    return 3 # user bust
  elsif (dealer_total > 21)
    return 4 # dealer bust
  end

  # Check for win
  if user_total > dealer_total
    return 5 # user win
  elsif user_total < dealer_total
    return 6 # dealer win
  end
end

def decide_dealer_action(hand)
  dealer_total = get_total(hand)

  # Aces are always counted as 11 if possible
  # without the dealer going over 21
  if has_ace?(hand) && dealer_total <= 11
    dealer_total += 10
  end

  return 'h' if dealer_total < 17

  'stand'    
end

def print_result
  case result
  when 0
    puts "Tie!"
  when 1
    puts "Blackjack! You won!"
  when 2
    puts "Blackjack, you lost!"
  when 3
    puts "You busted."
  when 4
    puts "Dealer busted, you won!"
  when 5
    puts "You won!"
  when 6
    puts "Dealer won."
  when 7
    puts "21, you won!"
  when 8
    puts "21, dealer won."
  end
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

user_standing = dealer_standing = (get_total(user) == 11 && has_ace?(user)) || (get_total(dealer) == 11 && has_ace?(dealer)) ? true : false

begin
  show_cards(user, dealer)

  if (!user_standing)
    puts "(H)it or (S)tand?"
    user_action = gets.chomp.downcase

    if (user_action == 'h')
      user << get_card(deck)
    else
      user_standing = true
    end
  end

  if (get_total(user) >= 21)
    user_standing = dealer_standing = true
    next
  end

  if (!dealer_standing)
    dealer_action = decide_dealer_action(dealer)

    if (dealer_action == 'h')
      dealer << get_card(deck)
    else
      dealer_standing = true
    end
  end

  if (get_total(dealer) >= 21)
    user_standing = dealer_standing = true
    next
  end
end until user_standing && dealer_standing

show_cards(user, dealer, false)
print_result(get_result(user, dealer))