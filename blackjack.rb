class Card

  attr_reader :suit, :face

  def initialize(suit, face)
    # Input:
    #  suit = "Club", Diamond", "Heart" or "Spade"
    #  face = 'Ace', 'King', 'Queen', 'Jack', 1', '2', '3', '4'...
    @suit = suit.to_s
    @face = face.to_s
  end

end

class Shoe


  def initialize(num_of_decks)
    # Input:
    #  Integer number of decks to use in shoe
    @cards = []
  end

  def shuffle

  end

  def deal_a_card

  end


end

module HandleCards

  def calculate_hand(hand)

  end

  def get_hand_status(hand)

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