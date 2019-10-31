require_relative('../db/sql_runner.rb')

class Movie

  attr_reader :id
  attr_accessor :title, :genre, :budget

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @genre = options['genre']
    @budget = options['budget']
  end

  def save()
    sql = "INSERT INTO movies (title, genre, budget) VALUES ($1, $2, $3) RETURNING id"
    values = [@title, @genre, @budget]
    movie = SqlRunner.run(sql, values)[0]
    @id = movie['id'].to_i
  end

  def delete()
    sql = "DELETE FROM movies WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE movies SET (
      title,
      genre,
      budget
    )
    =
    (
      $1, $2, $3
    )WHERE id = $4;"
  values = [@title, @genre, @budget, @id]
  SqlRunner.run(sql, values)
  end

  def stars()
    sql = "SELECT stars.* FROM stars INNER JOIN castings ON castings.star_id = stars.id WHERE movie_id = $1"
    values = [@id]
    stars = SqlRunner.run(sql, values)
    return stars.map{ |star|  Star.new(star)}
  end

  def remaining_budget()
    # self.stars()
    sql = "SELECT stars.* FROM stars INNER JOIN castings ON castings.star_id = stars.id WHERE movie_id = $1"
    values = [@id]
    stars = SqlRunner.run(sql, values)
    stars_of_movie = stars.map{ |star|  Star.new(star).id}
    fee_total = []
    for id in stars_of_movie
      sql = "SELECT castings.fee FROM castings WHERE castings.star_id = $1 RETURNING fee"
      values = [id]
      x = SqlRunner.run(sql, values)[0]
      fee_total << x['fee'].to_i
    end
    return fee_total.sum
  end

  def self.delete_all()
    sql = "DELETE FROM movies"
    SqlRunner.run(sql)
  end

  def self.all()
    sql = "SELECT * FROM movies"
    movies = SqlRunner.run(sql)
    return movies.map { |movie| Star.new(movie) }
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM movies WHERE id = $1;"
    values = [id]
    movie = SqlRunner.run(sql, values)[0]
    return Movie.new(movie)
  end


end
