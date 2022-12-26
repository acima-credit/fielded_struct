# frozen_string_literal: true

require 'bigdecimal/util'

module FieldedStruct
  module Types
    class Decimal < Base
      include Helpers::Numeric

      type :decimal
      base_type ::BigDecimal
      coercible_types ::Float, ::Numeric

      def initialize(attribute)
        super
        @scale = attribute[:scale]
        @round_mode = attribute[:round_mode] || :default
      end

      private

      def coerce_value(value)
        return nil if value == ''

        casted_value = \
          case value
          when ::Float
            coerce_float value
          when ::Numeric
            coerce_numeric value
          when ::String
            coerce_string value
          else
            value.respond_to?(:to_d) ? value.to_d : coerce_value(value.to_s)
          end

        apply_scale casted_value
      end

      def coerce_float(value)
        value.to_d
      end

      def coerce_numeric(value)
        value.to_d
      end

      def coerce_string(value)
        value.to_d
      rescue ArgumentError
        0.to_d
      end

      def apply_scale(value)
        return value unless @scale

        value.round @scale, @round_mode
      end

      def can_coerce?(value)
        string_coercible?(value) || type_coercible?(value)
      end

      def rejection_rx
        /\A\s*[+-]?\d/
      end
    end

    register_type Decimal
  end
end
