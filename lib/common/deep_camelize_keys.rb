class Common::DeepCamelizeKeys
  def self.to_camelized_hash(obj)
    case obj
    when Hash
      Hash[obj.map {|k, v| [camelize_key(k), to_camelized_hash(v)]}]
    when Array
      obj.map {|item| to_camelized_hash(item)}
    else
      obj
    end
  end

  def self.camelize_key(key)
    key.to_s.gsub(/_(.)/) {$1.upcase}.to_sym
  end
end
