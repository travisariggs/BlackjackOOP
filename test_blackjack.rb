require 'test/unit'
require_relative 'blackjack'


class TestCalculateHand < Test::Unit::TestCase

  include HandleCards

  # def setup
  # end

  # def teardown
  # end

  def test_king_8
    the_hand = [
      { value: 'King', suit: 'Spade'},
      { value:      8, suit: 'Heart'}
    ]

    assert_equal(18, calculate_hand(the_hand))
  end

  def test_jack_queen
    the_hand = [
        { value:  'Jack', suit: 'Club'  },
        { value: 'Queen', suit: 'Heart' }
    ]
    assert_equal(20, calculate_hand(the_hand))
  end

  def test_10_ace
    the_hand = [
        { value:    10, suit: 'Club'  },
        { value: 'Ace', suit: 'Heart' }
    ]
    assert_equal(21, calculate_hand(the_hand))
  end

  def test_ace_5_10
    the_hand = [
        { value: 'Ace', suit: 'Heart'   },
        { value:     5, suit: 'Diamond' },
        { value:    10, suit: 'Club'    },
    ]
    assert_equal(16, calculate_hand(the_hand))
  end

  def test_ace_ace_10_7
    the_hand = [
        { value: 'Ace', suit: 'Heart'   },
        { value: 'Ace', suit: 'Diamond' },
        { value:    10, suit: 'Club'    },
        { value:     7, suit: 'Club'    }
    ]
    assert_equal(19, calculate_hand(the_hand))
  end

  def test_ace_ace_ace_ace_10_9
    the_hand = [
        { value: 'Ace', suit: 'Heart'   },
        { value: 'Ace', suit: 'Diamond' },
        { value: 'Ace', suit: 'Spade'   },
        { value: 'Ace', suit: 'Club'    },
        { value:    10, suit: 'Club'    },
        { value:     9, suit: 'Heart'   }
    ]
    assert_equal(23, calculate_hand(the_hand))
  end

end


class TestHandStatus < Test::Unit::TestCase

  include HandleCards

  def test_blackjack
    assert_equal('Blackjack', hand_status?(21))
  end

  def test_bust_22
    assert_equal('Bust', hand_status?(22))
  end

  def test_bust_27
    assert_equal('Bust', hand_status?(27))
  end

  def test_playing_7
    assert_equal('Playing', hand_status?(7))
  end

end


class TestShuffle < Test::Unit::TestCase

  # def setup
  # end

  # def teardown
  # end

  def test_length
    shoe = Shoe.new(2)
    assert_equal(104, shoe.num_of_cards)
  end

  def test_ordered_and_shuffled_shoe
    ordered_shoe = Shoe.new(2)
    shuffled_shoe = Shoe.new(2)
    shuffled_shoe.shuffle_cards

    assert_not_equal(ordered_shoe, shuffled_shoe)
  end

  def test_check_all_cards_in_shuffled_shoe

    # Initialize expected result of true array
    expected = Array.new(52, true)
    # Intialize actual result as false array
    actual = Array.new(52, false)

    shoe = Shoe.new(1)

    i = 0

    # Create a 2-deck ordered shoe of cards
    [ 'Club', 'Diamond', 'Heart', 'Spade' ].each do |suit|

      ((2..10).to_a + ['Jack', 'Queen', 'King', 'Ace']).each do |card|

        card = Card.new(suit, card.to_s)

        # Does the shoe have this card?
        if shoe.has_card? card
          actual[i] = true
        end

        i += 1

      end

    end

    assert_equal(expected, actual)

  end

end


class TestCreateShoe < Test::Unit::TestCase

  def test_1_deck_length
    shoe = Shoe.new(1)
    assert_equal(52, shoe.num_of_cards)
  end

  def test_2_deck_length
    shoe = Shoe.new(2)
    assert_equal(2*52, shoe.num_of_cards)
  end

  def test_6_deck_length
    shoe = Shoe.new(6)
    assert_equal(6*52, shoe.num_of_cards)
  end

end


