# frozen_string_literal: true

module FieldedStruct
  module Types
    module Helpers
      module Numeric
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
        end

        private

        def can_coerce?(value)
          string_coercible?(value) || type_coercible?(value)
        end

        def string_coercible?(value)
          value.is_a?(::String) && !!value.to_s.match(rejection_rx)
        end
      end
    end
  end
end
