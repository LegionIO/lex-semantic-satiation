# frozen_string_literal: true

require 'legion/extensions/semantic_satiation/version'
require 'legion/extensions/semantic_satiation/helpers/constants'
require 'legion/extensions/semantic_satiation/helpers/concept'
require 'legion/extensions/semantic_satiation/helpers/satiation_engine'
require 'legion/extensions/semantic_satiation/runners/semantic_satiation'

module Legion
  module Extensions
    module SemanticSatiation
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
