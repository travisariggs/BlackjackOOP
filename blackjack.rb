#$$$$$$$$$$$$$$ CLASSES $$$$$$$$$$$$$$$
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
    @num_of_decks = num_of_decks
    @MIN_SHOE_SIZE = 12
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

    # Make sure we have enough cards
    if num_of_cards < @MIN_SHOE_SIZE
      puts 'Shoe was getting low on cards...'
      fill_shoe(@num_of_decks)
      shuffle_cards!
    end

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

  def new_hand
    @hand = BlackjackHand.new
  end

  def show_hand(mask=false)

    total = hand.calculate

    puts
    if mask
      puts "   #{name}'s hand is: ??"
    else
      puts "   #{name}'s hand is: #{total}"
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


class Blackjack

  def say(message)

    puts
    puts ' '*10 + message.to_s
    puts

    sleep(2.0)

  end

  def get_wager(total_money)

    # Make sure we keep asking until we get a valid bet
    while true

      say 'How much would you like to bet?'
      bet = gets.chomp

      if bet.to_i == 0
        say 'You have to bet something'
      elsif bet.to_i > total_money
        puts "You don't have that much money."
        puts "You can bet a max of $#{total_money}."
      else
        return bet.to_i
      end

    end

  end

  def get_y_n_answer(question, correction='You need to answer y or n')
    # Ask a yes or no question until the user provides a 'y' or 'n'
    #  Returns a string 'y' or 'n'
    #  On a failure, it could possibly return nil

    response = nil

    # Keep asking until we get a proper response
    while true

      say question
      response = gets.chomp.downcase

      if ['y', 'n'].include?(response)
        break
      else
        say correction
      end

    end

    response

  end

  def run

    # Create the Dealer
    dealer = BlackjackDealer.new

    # Create shoe
    shoe = Shoe.new(2)

    # Ask who's playing
    say ' '*10 + 'Welcome to Blackjack!'
    say "What's your name?"

    user_name = gets.chomp

    # Create player object
    player = BlackjackPlayer.new(user_name)

    # Be friendly...even though you're going to take their money
    say "Hello #{player.name}!  Nice to meet you!"

    # How much money will they start with?
    say 'How much money would you like to convert?'

    starting_money = gets.chomp.to_i
    player.money = starting_money


    # Loop through each hand that the user wants to play
    #  ...as long as they have money, of course...
    while player.money > 0

      # Ask for the user's bet
      wager = get_wager(player.money)

      # It's time to deal the initial cards
      player.add_card(shoe.deal_a_card!)
      dealer.add_card(shoe.deal_a_card!)

      player.add_card(shoe.deal_a_card!)
      dealer.add_card(shoe.deal_a_card!)

      # Display cards
      dealer.show_partial_hand
      player.show_hand

      # Check totals here to see if there was blackjack
      user_total = player.hand.calculate

      user_status = player.hand.status

      # Loop through user 'hits'
      while user_status == 'Playing'

        response = get_y_n_answer("Would you like a hit, #{player.name}? (y/n)")

        if response == 'y'

          player.add_card(shoe.deal_a_card!)

          # Calculate hand again...did we get to 21?
          user_total = player.hand.calculate

          player.show_hand

          # How did the user do?
          if player.hand.status == 'Blackjack'
            say 'Blackjack baby!'
            break
          elsif player.hand.status == 'Bust'
            say "Sorry #{player.name}...you busted"
            break
          end

        elsif response == 'n'
          break
        else
          next
        end

      end

      # Now it's the dealer's turn...(unless the user had Blackjack or bust)
      dealer.show_hand

      if player.hand.status == 'Playing'

        # Check totals here to see if there was blackjack
        dealer_total = dealer.hand.calculate

        # Loop through user 'hits'
        while dealer_total < 17

          say 'Dealer takes a hit...'
          dealer.add_card(shoe.deal_a_card!)

          # Calculate hand again...did we get to 21?
          dealer_total = dealer.hand.calculate

          dealer.show_hand

        end

      end

      # update the gains/losses
      if player.hand.status == 'Blackjack'
        say "#{player.name}, you won!"
        player.money += wager * 1.5
      elsif player.hand.status == 'Bust'
        say 'You lost this round.'
        player.money -= wager
      elsif player.hand.total > dealer.hand.total || dealer.hand.total > 21
        say "#{player.name}, you won!"
        player.money += wager
      elsif player.hand.total < dealer.hand.total
        say "Sorry #{player.name}, you lost this time."
        player.money -= wager
      elsif player.hand.total == dealer.hand.total
        say "It's a push."
      else
        say "SOMETHING WENT TERRIBLY WRONG!"
      end

      # Show results of betting
      say "#{player.name}, you have $#{player.money} left."

      # Reset hands
      player.new_hand
      dealer.new_hand

      # Make decisions about the next round
      break if player.money == 0

      answer = get_y_n_answer("Would you like to play another round, #{player.name}? (y/n)")

      break if answer == 'n'

    end  # End the Game Loop

    # Tell the user how they fared
    say "You started with $#{starting_money} and ended with $#{player.money}."

    if player.money > starting_money
      say "Congratulations, #{player.name}!"
    else
      say 'Sorry about your luck...'
    end

    # Say goodbye!
    say "Thanks for playing #{player.name}! Come back soon!"

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

  # d = BlackjackDealer.new
  # d.show_hand
  #
  # p = BlackjackPlayer.new('Travis')
  # p.show_hand
  #
  # # Create shoe
  # shoe = Shoe.new(2)
  #
  # # Deal cards
  # d.add_card(shoe.deal_a_card!)
  # p.add_card(shoe.deal_a_card!)
  #
  # d.add_card(shoe.deal_a_card!)
  # p.add_card(shoe.deal_a_card!)
  #
  # d.show_partial_hand
  # d.show_hand
  # p.show_hand
  #
  # # puts p.hand.calculate

  game = Blackjack.new
  game.run


end