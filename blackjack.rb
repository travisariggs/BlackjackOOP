class Card

  attr_reader :face, :suit

  def initialize(face, suit)
    # Input:
    #  face = 'Ace', 'King', 'Queen', 'Jack', 1', '2', '3', '4'...
    #  suit = "Club", Diamond", "Heart" or "Spade"
    @face = face.to_s
    @suit = suit.to_s
  end

  def show
    "#{face} of #{suit}s"
  end

  def eql?(another_card)
    suit == another_card.suit && face == another_card.face
  end

end

class Shoe

  def initialize(num_of_decks)
    # Input:
    #  Integer number of decks to use in shoe
    fill_shoe(num_of_decks)
    shuffle_cards!
  end

  def fill_shoe(num_of_decks)
    # Start with a fresh set of cards
    @cards = []
    num_of_decks.times do
      [ 'Club', 'Diamond', 'Heart', 'Spade'].each do |suit|
        ((2..10).to_a + ['Jack', 'Queen', 'King', 'Ace']).each do |card|
          # Append a Card object
          @cards << Card.new(suit, card)
        end
      end
    end

  end

  def num_of_cards
    @cards.length
  end

  def has_card?(card)
    # This is used for unit testing purposes
    # @cards.include?(card)
    @cards.each do |a_card|
      if card.suit == a_card.suit && card.face == a_card.face
        return true
      end
    end
    false
  end

  def shuffle_cards!
    @cards.shuffle!
  end

  def deal_a_card!
    @cards.pop
  end

end

class Hand

  attr_accessor :cards

  def initialize
    @cards = []
  end

  def add_card(card)
    @cards << card
  end

end


module HandleCards

  def calculate_hand(hand)

    total = 0
    ace_count = 0

    hand.cards.each do |card|

      if ['King', 'Queen', 'Jack'].include?(card.face)
        total += 10
      elsif card.face == 'Ace'
        ace_count += 1
      else
        total += card.face.to_i
      end

    end

    # Add the Aces as 11's
    total += ace_count * 11

    # Check to see if it's a bust
    #  and reduce the '11' to a '1'
    #  until we run out of aces or
    #  the total goes 21 or below
    if total > 21

      ace_count.times do

        # Change the 11 to a 1
        total -= 10

        # Check the total again
        if total <= 21
          break
        end

      end

    end

    # We've now changed as many aces
    #  to values of 1's that we could,
    #  (if we had any at all)
    total

  end

  def hand_status?(hand_total)

    if hand_total == 21
      status = 'Blackjack'
    elsif hand_total > 21
      status = 'Bust'
    else
      status = 'Playing'
    end

  end

end


class Dealer

  include HandleCards

  def initialize

  end

  def show_hand

  end

  def ask_for_wager

  end

  def deal_cards

  end

end

class Player

  include HandleCards

  def initialize(name)
    # Input:
    #  Player's name string
  end

  def show_hand

  end

end

########## Main Program ##################
if __FILE__ == $0

  card1 = Card.new('4', 'Heart')
  card2 = Card.new('4', 'Heart')

  puts card1.show

  a_hand = Hand.new

  a_hand.add_card(card1)
  a_hand.add_card(card2)

  puts a_hand.cards

end