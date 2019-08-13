require("pg")

class Property

  attr_accessor :address, :value, :number_of_bedrooms, :year_built
  attr_reader :id
  def initialize(options)
    @address = options['address']
    @value = options['value']
    @number_of_bedrooms = options['number_of_bedrooms'].to_i
    @year_built = options['year_built'].to_i
    @id = options['id'].to_i if options['id']
  end

  def save
    db = PG.connect({ dbname: 'properties', host: 'localhost'})
    sql = "
      INSERT INTO property (
        address,
        value,
        number_of_bedrooms,
        year_built
      )
      VALUES
      ($1, $2, $3, $4)
      RETURNING *
    "
    values = [@address, @value, @number_of_bedrooms, @year_built]
    db.prepare("save", sql)
    @id = db.exec_prepared("save", values)[0]["id"].to_i
    db.close()
  end

  def Property.all
    db = PG.connect({dbname: 'properties', host:'localhost'})
    sql = "SELECT * FROM property"
    db.prepare("all", sql)
    properties = db.exec_prepared("all")
    db.close()
    return properties.map { |property| Property.new(property) }
  end

  def update
    db = PG.connect({ dbname: 'properties', host: 'localhost'})
    sql = "
      UPDATE property SET  (
        address,
        value,
        number_of_bedrooms,
        year_built
      ) = (
        $1, $2, $3, $4
      )
        WHERE id = $5
    "
    values = [@address, @value, @number_of_bedrooms, @year_built, @id]
    db.prepare("update", sql)
    db.exec_prepared("update", values)
    db.close()
  end

  def Property.delete_all
    db = PG.connect({ dbname: 'properties', host: 'localhost'})
    sql = "DELETE FROM property"
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
    db.close()
  end

  def delete
    db = PG.connect({ dbname: 'properties', host: 'localhost'})
    sql = "DELETE FROM property WHERE id = $1"
    values = [@id]
    db.prepare("delete", sql)
    db.exec_prepared("delete", values)
    db.close()
  end

  def Property.find_by_id(id_number)
    db = PG.connect({ dbname: 'properties', host: 'localhost'})
    sql = "SELECT * FROM property WHERE id = $1"
    values = [id_number]
    db.prepare("find", sql)
    search_result = db.exec_prepared("find",values)
    db.close()
    return search_result.map { |result| Property.new(result) }
  end

end
