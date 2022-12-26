# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FieldedStruct::Types::Decimal, type: :type do
  describe 'class' do
    it { expect(described_class.ancestors).to include FieldedStruct::Types::Base }
    it { expect(described_class.type).to eq :decimal }
    it { expect(described_class.base_type).to eq BigDecimal }
    it { expect(described_class.coercible_types).to eq [Float, Numeric] }
  end
  # rubocop:disable Lint/BooleanSymbol
  describe 'instance' do
    subject { described_class.new attribute }
    let(:attribute_type) { :decimal }
    let(:attr_options) { base_attr_options.update scale: scale, round_mode: round_mode }
    let(:scale) { nil }
    let(:round_mode) { nil }
    context 'when non-coercible' do
      let(:coercible) { false }
      context '#coercible?' do
        it { expect(subject.coercible?(nil)).to eq false } # Nil
        it { expect(subject.coercible?(0)).to eq false } # Integer
        it { expect(subject.coercible?(3)).to eq false }
        it { expect(subject.coercible?(-3)).to eq false }
        it { expect(subject.coercible?(:some_symbol)).to eq false } # Symbol
        it { expect(subject.coercible?('0')).to eq false } # String
        it { expect(subject.coercible?('3.1')).to eq false }
        it { expect(subject.coercible?('-3.1')).to eq false }
        it { expect(subject.coercible?('wibble')).to eq false }
        it { expect(subject.coercible?(0.0)).to eq false } # Float
        it { expect(subject.coercible?(3.0)).to eq false }
        it { expect(subject.coercible?(-3.0)).to eq false }
        it { expect(subject.coercible?(true)).to eq false } # Boolean
        it { expect(subject.coercible?(false)).to eq false }
        it { expect(subject.coercible?(bd_value)).to eq true } # Decimal
        it { expect(subject.coercible?(date_value)).to eq false } # Date
        it { expect(subject.coercible?(datetime_value)).to eq false } # DateTime
        it { expect(subject.coercible?(time_value)).to eq false } # Time
      end
      context '#coerce' do
        it { expect(subject.coerce(nil)).to eq nil } # Nil
        it { expect(subject.coerce(0)).to eq nil } # Integer
        it { expect(subject.coerce(3)).to eq nil }
        it { expect(subject.coerce(-3)).to eq nil }
        it { expect(subject.coerce(:some_symbol)).to eq nil } # Symbol
        it { expect(subject.coerce(:'0')).to eq nil }
        it { expect(subject.coerce(:'1')).to eq nil }
        it { expect(subject.coerce(:true)).to eq nil }
        it { expect(subject.coerce(:false)).to eq nil }
        it { expect(subject.coerce(:on)).to eq nil }
        it { expect(subject.coerce(:off)).to eq nil }
        it { expect(subject.coerce('0')).to eq nil } # String
        it { expect(subject.coerce('3.1')).to eq nil }
        it { expect(subject.coerce('-3.1')).to eq nil }
        it { expect(subject.coerce('f')).to eq nil }
        it { expect(subject.coerce('F')).to eq nil }
        it { expect(subject.coerce('false')).to eq nil }
        it { expect(subject.coerce('FALSE')).to eq nil }
        it { expect(subject.coerce('False')).to eq nil }
        it { expect(subject.coerce('off')).to eq nil }
        it { expect(subject.coerce('Off')).to eq nil }
        it { expect(subject.coerce('true')).to eq nil }
        it { expect(subject.coerce('True')).to eq nil }
        it { expect(subject.coerce('TRUE')).to eq nil }
        it { expect(subject.coerce('On')).to eq nil }
        it { expect(subject.coerce('wibble')).to eq nil }
        it { expect(subject.coerce(0.0)).to eq nil } # Float
        it { expect(subject.coerce(3.0)).to eq nil }
        it { expect(subject.coerce(-3.0)).to eq nil }
        it { expect(subject.coerce(true)).to eq nil } # Boolean
        it { expect(subject.coerce(false)).to eq nil }
        it { expect(subject.coerce(bd_value)).to eq bd_value } # BigDecimal
      end
    end
    context 'when coercible' do
      let(:coercible) { true }
      context '#coercible?' do
        it { expect(subject.coercible?(nil)).to eq false } # Nil
        it { expect(subject.coercible?(0)).to eq true } # Integer
        it { expect(subject.coercible?(3)).to eq true }
        it { expect(subject.coercible?(-3)).to eq true }
        it { expect(subject.coercible?(:some_symbol)).to eq false } # Symbol
        it { expect(subject.coercible?('0')).to eq true } # String
        it { expect(subject.coercible?('3.1')).to eq true }
        it { expect(subject.coercible?('-3.1')).to eq true }
        it { expect(subject.coercible?('wibble')).to eq false }
        it { expect(subject.coercible?(0.0)).to eq true } # Float
        it { expect(subject.coercible?(3.0)).to eq true }
        it { expect(subject.coercible?(-3.0)).to eq true }
        it { expect(subject.coercible?(true)).to eq false } # Boolean
        it { expect(subject.coercible?(false)).to eq false }
        it { expect(subject.coercible?(bd_value)).to eq true } # Decimal
        it { expect(subject.coercible?(date_value)).to eq false } # Date
        it { expect(subject.coercible?(datetime_value)).to eq false } # DateTime
        it { expect(subject.coercible?(time_value)).to eq false } # Time
      end
      context '#coerce' do
        it { expect(subject.coerce(nil)).to eq nil } # Nil
        it { expect(subject.coerce(0)).to eq bd(0) } # Integer
        it { expect(subject.coerce(3)).to eq bd(3) }
        it { expect(subject.coerce(-3)).to eq bd(-3) }
        it { expect(subject.coerce(:some_symbol)).to eq nil } # Symbol
        it { expect(subject.coerce(:'0')).to eq nil }
        it { expect(subject.coerce(:'1')).to eq nil }
        it { expect(subject.coerce(:true)).to eq nil }
        it { expect(subject.coerce(:false)).to eq nil }
        it { expect(subject.coerce(:on)).to eq nil }
        it { expect(subject.coerce(:off)).to eq nil }
        it { expect(subject.coerce('0')).to eq bd(0) } # String
        it { expect(subject.coerce('3.1')).to eq bd(3.1) }
        it { expect(subject.coerce('-3.1')).to eq bd(-3.1) }
        it { expect(subject.coerce('f')).to eq nil }
        it { expect(subject.coerce('F')).to eq nil }
        it { expect(subject.coerce('false')).to eq nil }
        it { expect(subject.coerce('FALSE')).to eq nil }
        it { expect(subject.coerce('False')).to eq nil }
        it { expect(subject.coerce('off')).to eq nil }
        it { expect(subject.coerce('Off')).to eq nil }
        it { expect(subject.coerce('true')).to eq nil }
        it { expect(subject.coerce('True')).to eq nil }
        it { expect(subject.coerce('TRUE')).to eq nil }
        it { expect(subject.coerce('On')).to eq nil }
        it { expect(subject.coerce('wibble')).to eq nil }
        it { expect(subject.coerce(0.0)).to eq bd(0.0) } # Float
        it { expect(subject.coerce(3.1)).to eq bd(3.1) }
        it { expect(subject.coerce(-3.1)).to eq bd(-3.1) }
        it { expect(subject.coerce(true)).to eq nil } # Boolean
        it { expect(subject.coerce(false)).to eq nil }
        it { expect(subject.coerce(bd_value)).to eq bd_value } # BigDecimal
        context 'scale', :focus do
          context '2' do
            let(:scale) { 2 }
            context 'round_mode' do
              context 'missing' do
                let(:round_mode) { nil }
                it { expect(subject.coerce(3.145)).to eq bd(3.15) }
              end
              context 'up' do
                let(:round_mode) { :up }
                it { expect(subject.coerce(3.145)).to eq bd(3.15) }
              end
              context 'down/truncate' do
                let(:round_mode) { :down }
                it { expect(subject.coerce(3.145)).to eq bd(3.14) }
              end
              context 'half_up/default' do
                let(:round_mode) { :half_up }
                it { expect(subject.coerce(3.145)).to eq bd(3.15) }
              end
              context 'half_down' do
                let(:round_mode) { :half_down }
                it { expect(subject.coerce(3.145)).to eq bd(3.14) }
              end
              context 'half_even/banker' do
                let(:round_mode) { :half_even }
                it { expect(subject.coerce(3.145)).to eq bd(3.14) }
              end
              context 'ceiling/ceil' do
                let(:round_mode) { :ceiling }
                it { expect(subject.coerce(3.145)).to eq bd(3.15) }
              end
              context 'floor' do
                let(:round_mode) { :floor }
                it { expect(subject.coerce(3.145)).to eq bd(3.14) }
              end
            end
          end
        end
      end
    end
  end
  # rubocop:enable Lint/BooleanSymbol
end
