class Round < ActiveRecord::Base
  belongs_to :user
  belongs_to :deck
  has_many :guesses

 attr_reader :draw_pile, :discard_pile, :current_card


   def play
    until @draw_pile.empty?
      draw_card
      display_card
      get_guess
    end
    puts "No more cards!"
    reshuffle
  end

  def draw_card
    @current_card = @draw_pile.sample
    @draw_pile.delete(@current_card)
  end

  def display_card
    puts "Definition"
    puts "#{@current_card.definition}"
  end

  def get_guess
    print "Guess: "
    @guess = gets.chomp!
    guess_correct?
  end

  def guess_correct?
    if @guess == @current_card.term
      puts "Correct!"
      discard_current_card
    else
      puts "Incorrect! Try again."
      get_guess
    end
  end

  def discard_current_card
    @discard_pile << @current_card
  end

  def reshuffle
    @draw_pile << @discard_pile
    @draw_pile.flatten!
    @discard_pile = []
  end
end
