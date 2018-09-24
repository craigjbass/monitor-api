module LocalAuthority::Refinement::HashHasPath
  refine Hash do
    def hash_has_path?(path)
      dig(*path).nil? != true
    end
  end
end
