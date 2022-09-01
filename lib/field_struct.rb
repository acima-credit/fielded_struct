# frozen_string_literal: true

require 'digest/crc32'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/hash_with_indifferent_access'

require_relative 'field_struct/version'
require_relative 'field_struct/error'
require_relative 'field_struct/metadata'
require_relative 'field_struct/plugins'
require_relative 'field_struct/structs'
