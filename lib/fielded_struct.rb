# frozen_string_literal: true

require 'digest/crc32'
require 'bigdecimal'
require 'date'
require 'time'
require 'json'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/date'
require 'active_support/core_ext/date_time'
require 'active_support/core_ext/time'
require 'active_support/core_ext/integer'
require 'active_support/core_ext/string'
require 'active_support/hash_with_indifferent_access'
require 'active_support/time'
require 'active_support/deprecation'

require_relative 'fielded_struct/version'
require_relative 'fielded_struct/error'
require_relative 'fielded_struct/metadata'
require_relative 'fielded_struct/cache'
require_relative 'fielded_struct/types'
require_relative 'fielded_struct/plugins'
require_relative 'fielded_struct/structs'