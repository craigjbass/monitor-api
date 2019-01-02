class LocalAuthority::UseCase::FindPathData
  def execute(baseline_data:, path:)

    path = choose_path(baseline_data, path) if path[0] == :return_or_baseline 

    found = search_hash(baseline_data, path)
    if !(found.nil? || found.empty?)
      { found: found }
    else
      {}
    end
  end

  private

  def choose_path(baseline_data, path)
    if baseline_data[:return_data].empty?
      path[1]
    else
      path[2]
    end
  end

  def search_array(baseline_data, path)
    baseline_data.map do |x|
      search_hash(x[path.first], path.drop(1))
    end
  end

  def search_hash(baseline_data, path)
    if path.empty?
      baseline_data
    elsif baseline_data.class == Hash
      search_hash(baseline_data[path.first], path.drop(1))
    elsif baseline_data.class == Array
      search_array(baseline_data, path)
    end
  end
end
