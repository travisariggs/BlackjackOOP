class Card

  attr_reader :value, :suit

  def initialize(value, suit)
    # Input:
    #  face = 'Ace', 'King', 'Queen', 'Jack', 1', '2', '3', '4'...
    #  suit = "Club", Diamond", "Heart" or "Spade"
    @value = value.to_s
    @suit = suit.to_s
  end

  def show
    "#{value} of #{suit}s"
  end

  def eql?(another_card)
    suit == another_card.suit && value == another_card.value
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
          @cards << Card.new(card, suit)
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
      if card.suit == a_card.suit && card.value == a_card.value
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

class Hand < Array

  def add_card(card)
    self << card
  end

  def cards
    self
  end

end


class BlackjackHand < Hand

  attr_accessor :total

  def initialize
    @total = 0
  end

  def calculate

    total = 0
    ace_count = 0

    self.each do |card|

      if ['King', 'Queen', 'Jack'].include?(card.value)
        total += 10
      elsif card.value == 'Ace'
        ace_count += 1
      else
        total += card.value.to_i
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
    # Be sure to store the total to the object
    @total = total

  end

  def status

    calculate

    if total == 21
      status = 'Blackjack'
    elsif total > 21
      status = 'Bust'
    else
      status = 'Playing'
    end

  end

end

class BasePlayer
  attr_accessor :name, :hand

  def initialize(name)
    @name = name
    @hand = Hand.new
  end

  def add_card(card)
    @hand.add_card(card)
  end

end


class BlackjackBasePlayer < BasePlayer

  def initialize(name)
    @name = name
    @hand = BlackjackHand.new
  end

  def show_hand(mask=false)

    total = hand.calculate

    puts
    if mask
      puts "   Dealer's hand is: ??"
    else
      puts "   Dealer's hand is: #{total}"
    end

    hand.each_with_index { | card, index |
      # Hide the second card if mask is true
      if mask && index == 1
        puts ' '*10 + " *** Hidden Card *** "
      else
        puts ' '*10 + "  #{ card.value } of #{ card.suit }'s"
      end
    }

    # Add some delay to make it easier for the user
    #  to keep up with what is happening
    sleep(0.5)

  end

end

class BlackjackPlayer < BlackjackBasePlayer

  attr_accessor :money

end


class BlackjackDealer < BlackjackBasePlayer

  def initialize

    @name = 'Dealer'

    # Create empty hand of cards
    @hand = BlackjackHand.new

  end

  def show_partial_hand
    show_hand(true)
  end

end



########## Main Program ##################
if __FILE__ == $0

  # card1 = Card.new('4', 'Heart')
  # card2 = Card.new('4', 'Heart')
  #
  # puts card1.show
  #
  # a_hand = Hand.new
  #
  # a_hand.add_card(card1)
  # a_hand.add_card(card2)
  #
  # puts a_hand.cards
  #
  # puts

  d = BlackjackDealer.new
  d.show_hand

  p = BlackjackPlayer.new('Travis')
  p.show_hand

  # Create shoe
  shoe = Shoe.new(2)

  # Deal cards
  d.add_card(shoe.deal_a_card!)
  p.add_card(shoe.deal_a_card!)

  d.add_card(shoe.deal_a_card!)
  p.add_card(shoe.deal_a_card!)

  d.show_partial_hand
  d.show_hand
  p.show_hand

  # puts p.hand.calculate


end