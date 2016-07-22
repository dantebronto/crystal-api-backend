class Users::Repository
  include RepositoryHelpers

  def all
    results = query("SELECT * FROM users ORDER BY created_at DESC")
    results.map {|x| Model.from_sql(x) }
  end

  def find(id)
    results = query("SELECT * FROM users WHERE id = $1 LIMIT 1", [id])
    raise RecordNotFound.new if results.size == 0
    Model.from_sql(results.first)
  end

  def create(user)
    results = query(%(
      INSERT into users (name, created_at, updated_at)
      VALUES ($?, $?, $?)
      RETURNING *
    ), [user.name, Time.now, Time.now])
    Model.from_sql(results.first)
  end

  def update(user)
    results = query(%(
      UPDATE users
      set name = $?, updated_at = $?
      WHERE id = $?
      RETURNING *
    ), [user.name, Time.now, user.id])
    Model.from_sql(results.first)
  end

  def delete(user)
    query("DELETE from users WHERE id = $?", [user.id])
  end
end
