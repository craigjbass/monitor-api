module LocalAuthority::Refinement::DeepCopy
  refine Hash do
    def deep_copy
      Marshal.load(Marshal.dump(self))
    end
  end
end
