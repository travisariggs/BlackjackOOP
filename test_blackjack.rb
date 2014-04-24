require 'test/unit'
require_relative 'blackjack'


class TestCalculateHand < Test::Unit::TestCase

  def setup
    @a_hand = BlackjackHand.new
  end

  # def teardown
  # end

  def test_player_calc
    p = Player.new('Travis')

    p.add_card(Card.new('King', 'Spade'))
    p.add_card(Card.new('7', 'Club'))

    assert_equal(17, p.hand.calculate)
  end

  def test_king_8
    @a_hand.add_card(Card.new('King', 'Spade'))
    @a_hand.add_card(Card.new('8', 'Heart'))

    assert_equal(18, @a_hand.calculate)
  end

  def test_jack_queen
    @a_hand.add_card(Card.new('Jack', 'Club'))
    @a_hand.add_card(Card.new('Queen', 'Heart'))

    assert_equal(20, @a_hand.calculate)
  end

  def test_10_ace
    @a_hand.add_card(Card.new('10', 'Club'))
    @a_hand.add_card(Card.new('Ace', 'Heart'))

    assert_equal(21, @a_hand.calculate)
  end

  def test_ace_5_10
    @a_hand.add_card(Card.new('Ace', 'Heart'))
    @a_hand.add_card(Card.new('5', 'Diamond'))
    @a_hand.add_card(Card.new('10', 'Club'))

    assert_equal(16, @a_hand.calculate)
  end

  def test_ace_ace_10_7
    @a_hand.add_card(Card.new('Ace', 'Heart'))
    @a_hand.add_card(Card.new('Ace', 'Diamond'))
    @a_hand.add_card(Card.new('10',  'Club'))
    @a_hand.add_card(Card.new('7',   'Club'))

    assert_equal(19, @a_hand.calculate)
  end

  def test_ace_ace_ace_ace_10_9
    @a_hand.add_card(Card.new('Ace', 'Heart'))
    @a_hand.add_card(Card.new('Ace', 'Diamond'))
    @a_hand.add_card(Card.new('Ace', 'Spade'))
    @a_hand.add_card(Card.new('Ace', 'Club'))
    @a_hand.add_card(Card.new('10',  'Club'))
    @a_hand.add_card(Card.new('9',   'Heart'))

    assert_equal(23, @a_hand.calculate)
  end

end


class TestHandStatus < Test::Unit::TestCase

  def setup
    @a_hand = BlackjackHand.new
  end

  def test_blackjack
    @a_hand.add_card(Card.new('King', 'Heart'))
    @a_hand.add_card(Card.new('Ace', 'Heart'))
    assert_equal('Blackjack', @a_hand.status)
  end

  def test_bust_22
    @a_hand.add_card(Card.new('King',  'Heart'))
    @a_hand.add_card(Card.new('Queen', 'Club'))
    @a_hand.add_card(Card.new('2',     'Spade'))
    assert_equal('Bust', @a_hand.status)
  end

  def test_bust_27
    @a_hand.add_card(Card.new('King',  'Heart'))
    @a_hand.add_card(Card.new('Queen', 'Club'))
    @a_hand.add_card(Card.new('7',     'Spade'))
    assert_equal('Bust', @a_hand.status)
  end

  def test_playing_7
    @a_hand.add_card(Card.new('3', 'Club'))
    @a_hand.add_card(Card.new('4', 'Spade'))
    assert_equal('Playing', @a_hand.status)
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
    ordered_shoe.fill_shoe(2)
    shuffled_shoe = Shoe.new(2)

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

        card = Card.new(card.to_s, suit)

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


