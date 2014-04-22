class Card

  attr_reader :suit, :face

  def initialize(suit, face)
    # Input:
    #  suit = "Club", Diamond", "Heart" or "Spade"
    #  face = 'Ace', 'King', 'Queen', 'Jack', 1', '2', '3', '4'...
    @suit = suit.to_s
    @face = face.to_s
  end

  def show
    "#{face} of #{suit}s"
  end

end

class Shoe

  def initialize(num_of_decks)
    # Input:
    #  Integer number of decks to use in shoe
    @cards = []
  end

  def num_of_cards

  end

  def has_card?(card)
    # This is used for unit testing purposes
  end

  def shuffle_cards

  end

  def deal_a_card

  end


end

module HandleCards

  def calculate_hand(hand)

  end

  def hand_status?(hand)

  end

end

class Dealer

  include HandleCards

  def initialize

  end

  def show_hand

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

  card = Card.new('Heart', '4')

  puts card.show

end