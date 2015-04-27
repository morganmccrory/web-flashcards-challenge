enable :sessions

helpers do
  def login?
    if session[:id].nil?
      return false
    else
      return true
    end
  end
end

get "/" do
  # @user = User.find_by(id: session[:id])
  erb :index
end

get '/users/new' do
  erb :"users/new"
end

post '/users' do
  user = User.create(params[:user])
  if user.valid?
    session[:user_id] = user.id
    redirect "/rounds"
  else
    errors = user.errors.messages
    erb :"users/new"
  end
end

post '/login' do
  @user = User.find_by_email(params[:email])
  if @user.password == params[:user][:password] #this is calling the password method, not getting actual password
    session[:user_id] = @user.id
    redirect "/rounds"
  else
    @errors = @user.errors.messages
    erb :index
  end
end

get '/rounds' do
  @user = User.find_by(id: session[:user_id])
  erb :"rounds/index"
end

post '/rounds' do
  @user = User.find_by(id: session[:user_id])
  @deck = Deck.find(1)
  @round = @deck.rounds.create(user: @user)
  redirect "/rounds/#{@round.id}"
end


get "/rounds/answer" do
  @user = User.find_by(id: session[:user_id])
  @deck = Deck.find(1)
  @played_cards = @deck.cards.where(played: true)
  @last_card = @played_cards.last
  @round = Round.find_by(user: @user)
  @guess = @last_card.guesses.last
  @cards = @deck.cards.where(played: false)
  puts "You're doing great"
  erb :"rounds/answer"
end

get '/rounds/results' do
  @user = User.find_by(id: session[:user_id])
  @round = Round.find_by(user: @user)
  @guesses = Guess.where(round_id: @round.id)
  @correct_guesses = @guesses.where(correctness: true)
  @incorrect_guesses = @guesses.where(correctness: false)
  erb :"rounds/results"
end

get '/rounds/:round_id' do
  @user = User.find_by(id: session[:user_id])
  @deck = Deck.find(1)
  @cards = @deck.cards.where(played: false)
  @round = Round.find_by(user: @user)
  erb :"rounds/cards"
end

post '/rounds/:round_id' do
  @user = User.find_by(id: session[:user_id])
  @deck = Deck.find(1)
  @cards = @deck.cards.where(played: false)
  @card = @cards.first
  @round = Round.find_by(user: @user)
  puts params[:guess].downcase
  puts @card.answer.downcase
  if params[:guess].downcase == @card.answer.downcase
    @guess = @card.guesses.create(round: @round, correctness: true)
  else
    @guess = @card.guesses.create(round: @round, correctness: false)
  end
  puts "YOU DID IT!!!"
  @card.update_attributes(played: true)
  redirect '/rounds/answer'
end


get "/logout" do
  session[:user_id] = nil
  redirect "/"
end
