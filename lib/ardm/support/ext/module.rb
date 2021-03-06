module Ardm; module Ext
  module Module

    # @api semipublic
    def self.find_const(mod, const_name)
      if const_name[0..1] == '::'
        Ardm::Ext::Object.full_const_get(const_name[2..-1])
      else
        nested_const_lookup(mod, const_name)
      end
    end

  private

    # Doesn't do any caching since constants can change with remove_const
    def self.nested_const_lookup(mod, const_name)
      unless mod.equal?(::Object)
        constants = []

        mod.name.split('::').each do |part|
          const = constants.last || ::Object
          constants << const.const_get(part)
        end

        parts = const_name.split('::')

        # from most to least specific constant, use each as a base and try
        # to find a constant with the name const_name within them
        constants.reverse_each do |const|
          # return the nested constant if available
          return const if parts.all? do |part|
            const = if RUBY_VERSION >= '1.9.0'
              const.const_defined?(part, false) ? const.const_get(part, false) : nil
            else
              const.const_defined?(part) ? const.const_get(part) : nil
            end
          end
        end
      end

      # no relative constant found, fallback to an absolute lookup and
      # use const_missing if not found
      Ardm::Ext::Object.full_const_get(const_name)
    end

  end
end; end
