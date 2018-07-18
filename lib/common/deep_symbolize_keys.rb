module Common
  class DeepSymbolizeKeys
    def self.to_symbolized_hash(obj)
      case obj
      when Hash
        result = {}
        obj.each do |key, value|
          result[key.to_sym] = to_symbolized_hash(value)
        end
        result
      when Array
        obj.map {|value| to_symbolized_hash(value)}
      else
        obj
      end
    end
  end
end