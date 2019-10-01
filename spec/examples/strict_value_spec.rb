# frozen_string_literal: true

require 'spec_helper'

module FieldStruct
  module Examples
    class UserStrictValue < FieldStruct.strict_value
      attribute :username, :string, :required, :strict, format: /^[a-z]/i
      attribute :password, :string, :optional, :strict
      attribute :age, :integer, :coercible
      attribute :owed, :float, :coercible
      attribute :source, :string, :coercible, enum: %w[A B C]
      attribute :level, :integer, default: -> { 2 }
      attribute :at, :time, :optional
    end
  end
end

RSpec.describe FieldStruct::Examples::UserStrictValue do
  let(:str) { "#<#{described_class.name} #{fields_str}>" }

  let(:username) { 'johnny' }
  let(:password) { 'p0ssw3rd' }
  let(:age) { 3 }
  let(:owed) { 20.75 }
  let(:source) { 'A' }
  let(:level) { 3 }
  let(:at) { nil }
  let(:params) do
    {
      username: username,
      password: password,
      age: age,
      owed: owed,
      source: source,
      level: level,
      at: at
    }
  end
  subject { described_class.new params }

  context 'class' do
    let(:attr_names) { %i[username password age owed source level at] }
    it('attribute_names') { expect(described_class.attribute_names).to eq attr_names }
    context 'attributes' do
      context 'username' do
        subject { described_class.attributes[:username] }
        let(:str) do
          '#<FieldStruct::Attribute name=:username type="string" ' \
            'options={:required=>true, :coercible=>false, :format=>/^[a-z]/i}>'
        end
        it { expect(subject.name).to eq :username }
        it { expect(subject.type).to be_a FieldStruct::Types::String }
        it { expect(subject.required?).to eq true }
        it { expect(subject.coercible?).to eq false }
        it { expect(subject.default?).to eq false }
        it { expect(subject.to_s).to eq str }
      end
      context 'password' do
        subject { described_class.attributes[:password] }
        let(:str) do
          '#<FieldStruct::Attribute name=:password type="string" options={:required=>false, :coercible=>false}>'
        end
        it { expect(subject.name).to eq :password }
        it { expect(subject.type).to be_a FieldStruct::Types::String }
        it { expect(subject.required?).to eq false }
        it { expect(subject.coercible?).to eq false }
        it { expect(subject.default?).to eq false }
        it { expect(subject.to_s).to eq str }
      end
      context 'age' do
        subject { described_class.attributes[:age] }
        let(:str) { '#<FieldStruct::Attribute name=:age type="integer" options={:required=>true, :coercible=>true}>' }
        it { expect(subject.name).to eq :age }
        it { expect(subject.type).to be_a FieldStruct::Types::Integer }
        it { expect(subject.required?).to eq true }
        it { expect(subject.coercible?).to eq true }
        it { expect(subject.default?).to eq false }
        it { expect(subject.to_s).to eq str }
      end
      context 'owed' do
        subject { described_class.attributes[:owed] }
        let(:str) { '#<FieldStruct::Attribute name=:owed type="float" options={:required=>true, :coercible=>true}>' }
        it { expect(subject.name).to eq :owed }
        it { expect(subject.type).to be_a FieldStruct::Types::Float }
        it { expect(subject.required?).to eq true }
        it { expect(subject.coercible?).to eq true }
        it { expect(subject.default?).to eq false }
        it { expect(subject.to_s).to eq str }
      end
      context 'source' do
        subject { described_class.attributes[:source] }
        let(:str) do
          '#<FieldStruct::Attribute name=:source type="string" ' \
            'options={:required=>true, :coercible=>true, :enum=>["A", "B", "C"]}>'
        end
        it { expect(subject.name).to eq :source }
        it { expect(subject.type).to be_a FieldStruct::Types::String }
        it { expect(subject.required?).to eq true }
        it { expect(subject.coercible?).to eq true }
        it { expect(subject.default?).to eq false }
        it { expect(subject.to_s).to eq str }
      end
      context 'level' do
        subject { described_class.attributes[:level] }
        it { expect(subject.name).to eq :level }
        it { expect(subject.type).to be_a FieldStruct::Types::Integer }
        it { expect(subject.required?).to eq true }
        it { expect(subject.coercible?).to eq false }
        it { expect(subject.default?).to eq true }
      end
      context 'at' do
        subject { described_class.attributes[:at] }
        let(:str) { '#<FieldStruct::Attribute name=:at type="time" options={:required=>false, :coercible=>false}>' }
        it { expect(subject.name).to eq :at }
        it { expect(subject.type).to be_a FieldStruct::Types::Time }
        it { expect(subject.required?).to eq false }
        it { expect(subject.coercible?).to eq false }
        it { expect(subject.default?).to eq false }
        it { expect(subject.to_s).to eq str }
      end
    end
  end

  context 'instance' do
    context 'basic' do
      shared_examples 'a valid field struct' do
        let(:fields_str) do
          'username="johnny" password="p0ssw3rd" age=3 owed=20.75 source="A" level=3 at=nil'
        end
        let(:values) { [username, password, age, owed, source, level, at] }
        it('to_s      ') { expect(subject.to_s).to eq str }
        it('inspect   ') { expect(subject.inspect).to eq str }
        it('username  ') { expect(subject.username).to eq username }
        it('password  ') { expect(subject.password).to eq password }
        it('age       ') { expect(subject.age).to eq age }
        it('owed      ') { expect(subject.owed).to eq owed }
        it('source    ') { expect(subject.source).to eq source }
        it('level     ') { expect(subject.level).to eq level }
        it('at        ') { expect(subject.at).to eq at }
        it('values    ') { expect(subject.values).to eq values }
      end
      context 'instantiate by hash' do
        it_behaves_like 'a valid field struct'
      end
      context 'instantiate by args' do
        subject { described_class.new username, password, age, owed, source, level, at }
        it_behaves_like 'a valid field struct'
      end
      context 'instantiate by args and hash' do
        subject { described_class.new username, password, age, owed, source: source, level: level, at: at }
        it_behaves_like 'a valid field struct'
      end
    end

    context 'with' do
      let(:error_class) { FieldStruct::BuildError }
      context 'username' do
        context 'missing' do
          let(:params) { { password: password, age: age, owed: owed, source: source } }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':username is required'
          end
        end
        context 'empty' do
          let(:username) { '' }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':username is required'
          end
        end
        context 'nil' do
          let(:username) { nil }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':username is required'
          end
        end
        context 'wrong format' do
          let(:username) { '123' }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':username is not in a valid format'
          end
        end
      end
      context 'password' do
        context 'missing' do
          let(:params) { { username: username, age: age, owed: owed, source: source } }
          it('is ok') { expect(subject.password).to be_nil }
        end
        context 'empty' do
          let(:password) { '' }
          it('is ok') { expect(subject.password).to eq '' }
        end
        context 'nil' do
          let(:password) { nil }
          it('is ok') { expect(subject.password).to be_nil }
        end
      end
      context 'age' do
        context 'missing' do
          let(:params) { { username: username, password: password, owed: owed, source: source } }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':age is required'
          end
        end
        context 'empty' do
          let(:age) { '' }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':age is required'
          end
        end
        context 'nil' do
          let(:age) { nil }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':age is required'
          end
        end
        context 'string' do
          let(:age) { '35' }
          it('is ok') { expect(subject.age).to eq 35 }
        end
        context 'float' do
          let(:age) { 24.32 }
          it('is ok') { expect(subject.age).to eq 24 }
        end
      end
      context 'owed' do
        context 'missing' do
          let(:params) { { username: username, password: password, age: age, source: source } }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':owed is required'
          end
        end
        context 'empty' do
          let(:owed) { '' }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':owed is required'
          end
        end
        context 'nil' do
          let(:owed) { nil }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':owed is required'
          end
        end
        context 'invalid' do
          let(:owed) { '$3.o1' }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':owed is required'
          end
        end
        context '0.0' do
          context 'as string' do
            let(:owed) { '0.0' }
            let(:fields_str) { 'username="johnny" password="p0ssw3rd" age=3 owed=0.0 source="A" level=3 at=nil' }
            it('to_s      ') { expect(subject.to_s).to eq str }
            it('owed    ') { expect(subject.owed).to eq owed.to_f }
          end
          context 'as float' do
            let(:owed) { 0.0 }
            let(:fields_str) { 'username="johnny" password="p0ssw3rd" age=3 owed=0.0 source="A" level=3 at=nil' }
            it('to_s      ') { expect(subject.to_s).to eq str }
            it('owed    ') { expect(subject.owed).to eq owed.to_f }
          end
          context 'as integer' do
            let(:owed) { 0 }
            let(:fields_str) { 'username="johnny" password="p0ssw3rd" age=3 owed=0.0 source="A" level=3 at=nil' }
            it('to_s      ') { expect(subject.to_s).to eq str }
            it('owed    ') { expect(subject.owed).to eq owed.to_f }
          end
          context 'as decimal' do
            let(:owed) { BigDecimal '0' }
            let(:fields_str) { 'username="johnny" password="p0ssw3rd" age=3 owed=0.0 source="A" level=3 at=nil' }
            it('to_s      ') { expect(subject.to_s).to eq str }
            it('owed    ') { expect(subject.owed).to eq owed.to_f }
          end
        end
        context '12.34' do
          context 'as string' do
            let(:owed) { '12.34' }
            let(:fields_str) { 'username="johnny" password="p0ssw3rd" age=3 owed=12.34 source="A" level=3 at=nil' }
            it('to_s      ') { expect(subject.to_s).to eq str }
            it('owed    ') { expect(subject.owed).to eq owed.to_f }
          end
          context 'as float' do
            let(:owed) { 12.34 }
            let(:fields_str) { 'username="johnny" password="p0ssw3rd" age=3 owed=12.34 source="A" level=3 at=nil' }
            it('to_s      ') { expect(subject.to_s).to eq str }
            it('owed    ') { expect(subject.owed).to eq owed.to_f }
          end
          context 'as decimal' do
            let(:owed) { BigDecimal '12.34' }
            let(:fields_str) { 'username="johnny" password="p0ssw3rd" age=3 owed=12.34 source="A" level=3 at=nil' }
            it('to_s      ') { expect(subject.to_s).to eq str }
            it('owed    ') { expect(subject.owed).to eq owed.to_f }
          end
        end
        context '-12.34' do
          context 'as string' do
            let(:owed) { '-12.34' }
            let(:fields_str) { 'username="johnny" password="p0ssw3rd" age=3 owed=-12.34 source="A" level=3 at=nil' }
            it('to_s      ') { expect(subject.to_s).to eq str }
            it('owed    ') { expect(subject.owed).to eq owed.to_f }
          end
          context 'as float' do
            let(:owed) { -12.34 }
            let(:fields_str) { 'username="johnny" password="p0ssw3rd" age=3 owed=-12.34 source="A" level=3 at=nil' }
            it('to_s      ') { expect(subject.to_s).to eq str }
            it('owed    ') { expect(subject.owed).to eq owed.to_f }
          end
          context 'as decimal' do
            let(:owed) { BigDecimal '-12.34' }
            let(:fields_str) { 'username="johnny" password="p0ssw3rd" age=3 owed=-12.34 source="A" level=3 at=nil' }
            it('to_s      ') { expect(subject.to_s).to eq str }
            it('owed    ') { expect(subject.owed).to eq owed.to_f }
          end
        end
        context '$12,345.67' do
          context 'as string' do
            let(:owed) { '$12,345.67' }
            let(:fields_str) { 'username="johnny" password="p0ssw3rd" age=3 owed=12345.67 source="A" level=3 at=nil' }
            it('to_s      ') { expect(subject.to_s).to eq str }
            it('owed    ') { expect(subject.owed).to eq owed.gsub(/\$|\,/, '').to_f }
          end
        end
        context '$-12,345.67' do
          context 'as string' do
            let(:owed) { '$-12,345.67' }
            let(:fields_str) { 'username="johnny" password="p0ssw3rd" age=3 owed=-12345.67 source="A" level=3 at=nil' }
            it('to_s      ') { expect(subject.to_s).to eq str }
            it('owed    ') { expect(subject.owed).to eq owed.gsub(/\$|\,/, '').to_f }
          end
        end
      end
      context 'source' do
        context 'missing' do
          let(:params) { { username: username, password: password, age: age, owed: owed } }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':source is required'
          end
        end
        context 'empty' do
          let(:source) { '' }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':source is required'
          end
        end
        context 'nil' do
          let(:source) { nil }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':source is required'
          end
        end
        context 'unknown' do
          let(:source) { 'unknown' }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':source is not included in list'
          end
        end
        context 'wrong case' do
          let(:source) { 'a' }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':source is not included in list'
          end
        end
      end
      context 'level' do
        context 'missing' do
          let(:params) { { username: username, password: password, age: age, owed: owed, source: source } }
          it('uses the default') { expect(subject.level).to eq 2 }
        end
        context 'empty' do
          let(:level) { '' }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':level is required'
          end
        end
        context 'nil' do
          let(:level) { nil }
          it 'throws an exception' do
            expect { subject }.to raise_error error_class, ':level is required'
          end
        end
      end
      context 'no params' do
        subject { described_class.new }
        it 'does raise a build error' do
          expect { subject }.to raise_error error_class, ':username is required'
        end
      end
    end

    context 'immutability' do
      let(:error_class) { NoMethodError }
      context 'username' do
        it('responds_to') { expect(subject.respond_to?(:username=)).to eq false }
        it { expect { subject.username = 'other' }.to raise_error(error_class, /undefined method `username='/) }
      end
      context 'password' do
        it('responds_to') { expect(subject.respond_to?(:password=)).to eq false }
        it { expect { subject.password = 'other' }.to raise_error(error_class, /undefined method `password='/) }
      end
      context 'age' do
        it('responds_to') { expect(subject.respond_to?(:age=)).to eq false }
        it { expect { subject.age = 2 }.to raise_error(error_class, /undefined method `age='/) }
      end
      context 'owed' do
        it('responds_to') { expect(subject.respond_to?(:owed=)).to eq false }
        it { expect { subject.owed = 'other' }.to raise_error(error_class, /undefined method `owed='/) }
      end
      context 'source' do
        it('responds_to') { expect(subject.respond_to?(:source=)).to eq false }
        it { expect { subject.source = 'other' }.to raise_error(error_class, /undefined method `source='/) }
      end
    end
  end
end
