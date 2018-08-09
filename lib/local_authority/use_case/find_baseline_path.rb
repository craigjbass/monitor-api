class LocalAuthority::UseCase::FindBaselinePath
  def execute(baseline_data, path)
    search_hash(baseline_data, path)
  end

  private

  def search_array(baseline_data, path)
    baseline_data.map do |x|
      search_hash(x[path.first], path.drop(1))
    end
  end

  def search_hash(baseline_data, path)
    if path.empty?
      baseline_data
    else
      if baseline_data.class == Hash
        search_hash(baseline_data[path.first], path.drop(1))
      elsif baseline_data.class == Array
        search_array(baseline_data, path)
      end
    end
  end
end
