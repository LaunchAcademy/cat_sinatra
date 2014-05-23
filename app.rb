require 'sinatra'
require 'sinatra/reloader'
require 'csv'

def all_cats
  cats = []

  CSV.foreach('cats.csv', headers: true, header_converters: :symbol) do |cat|
    cats << cat.to_hash
  end

  cats
end

def save_cat(cat)
  CSV.open('cats.csv', 'a') do |csv|
    csv << [cat[:name], cat[:breed], cat[:description]]
  end
end

def cat_errors(cat)
  errors = []

  cat.each do |key, val|
    unless present?(val)
      errors << "#{key.capitalize} is required"
    end
  end

  errors
end

def present?(value)
  value != nil && value != ""
end

get '/' do
  @cats = all_cats
  erb :index
end

get '/cats/new' do
  @cat = {}
  erb :'cats/new'
end

post '/cats' do
  @cat = params['cat']
  @errors = cat_errors(@cat)

  if @errors.empty?
    save_cat(@cat)
    redirect '/'
  else
    erb :'cats/new'
  end
end
