# frozen_string_literal: true

module FieldedStruct
  module Types
    class Integer < Base
      include Helpers::Numeric

      type :integer
      base_type ::Integer
      coercible_types ::Numeric

      private

      def coerce_value(value)
        value.to_i
      end

      def rejection_rx
        /\A\s*[+-]?\d/
      end

      def numeric_coercible?(value)
        value.is_a?(::Numeric) && value.respond_to?(:to_i)
      end
    end

    register_type Integer
  end
end
