require_relative('../db/sql_runner.rb')

class Casting

  attr_reader :id
  attr_accessor :fee, :movie_id, :star_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @fee = options['fee']
    @movie_id = options['movie_id']
    @star_id = options['star_id']
  end

  def save()
    sql = "INSERT INTO castings (fee, movie_id, star_id) VALUES ($1, $2, $3) RETURNING id"
    values = [@fee, @movie_id, @star_id]
    casting = SqlRunner.run(sql, values)[0]
    @id = casting['id'].to_i
  end

  def delete()
    sql = "DELETE FROM castings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE castings SET (
      star_id,
      movie_id,
      fee
    )
    =
    (
      $1, $2,$3
    )WHERE id = $4;"
  values = [@star_id, @movie_id, @fee, @id]
  SqlRunner.run(sql, values)
  end


  def self.delete_all()
    sql = "DELETE FROM castings"
    SqlRunner.run(sql)
  end

  def self.all()
    sql = "SELECT * FROM castings"
    castings = SqlRunner.run(sql)
    return castings.map { |casting| Star.new(casting) }
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM castings WHERE id = $1;"
    values = [id]
    casting = SqlRunner.run(sql, values)[0]
    return Casting.new(casting)
  end

end
