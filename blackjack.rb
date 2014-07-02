# keep cards in a hash
# keep deck in an array

# create the deck
# user gets a card
# dealer gets a card
# user gets a card
# dealer gets a card
# player can see dealer's first card

# until someone busts or wins
#   player can choose to hit or stay, if not already stayed

#   if player stays
#     dealer decides what to do
#     check if busts or wins

#   if player hits
#     player gets a card
#     check if busts or wins
#     dealer decides what to do
#     check if busts or wins


# dealer decision
#   if cards < 17 hit
#   else stay

require 'pry'

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
  # TODO: What happens if there are no cards?
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

  # binding.pry
  card_name + ' of ' + suit_name
end

def show_cards(user_deck, dealer_deck)
  print 'User cards: '
  user_deck.each_with_index do |card, i|
    print card_name(card)
    print ', ' if i < user_deck.size - 1
  end

  puts

  print 'Dealer cards: '
  dealer_deck.each_with_index do |card, i|
    if i == 0
      print 'XXXXXXXXXXX'
    else
      print card_name(card)
    end

    print ', ' if i < dealer_deck.size - 1
  end

  puts
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

show_cards(user, dealer)

