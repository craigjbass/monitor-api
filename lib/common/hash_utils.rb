class Common::HashUtils
  def self.hash_has_path(hash, path)
    hash.dig(*path).nil? != true
  end
end
