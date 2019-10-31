require_relative('./models/casting')
require_relative('./models/movie')
require_relative('./models/star')

require('pry-byebug')

Star.delete_all()
Movie.delete_all()
Casting.delete_all()

star1 = Star.new( { 'first_name' => 'Brad', 'last_name' => 'Pitt' })
star1.save()
star2 = Star.new( { 'first_name' => 'Jason', 'last_name' => 'Statham' })
star2.save()

movie1 = Movie.new( {'title' => 'Big Short', 'genre' => 'drama', 'budget' => 1000} )
movie2 = Movie.new( {'title' => 'Mechanic', 'genre' => 'action', 'budget' => 2000} )
movie1.save()
movie2.save()

casting1 = Casting.new( {'fee' => 500, 'movie_id' => movie2.id, 'star_id' => star2.id} )
casting2 = Casting.new( {'fee' => 300, 'movie_id' => movie2.id, 'star_id' => star1.id} )
casting1.save()
casting2.save()

binding.pry

nil
