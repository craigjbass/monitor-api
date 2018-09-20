module LocalAuthority::Refinement::HashDeepMerge
  refine Hash do
    def deep_merge(second)
      first = self
      merger = proc do |_key, v1, v2|
        if v1.class == Hash && v2.class == Hash
          v1.merge(v2, &merger)
        else
          if v1.class == Array && v2.class == Array
            v1 | v2
          else
            [:undefined, nil, :nil].include?(v2) ? v1 : v2
          end
        end
      end
      first.merge(second.to_h, &merger)
    end
  end
end
