require 'opal-parser'
require 'i18n'
require 'i18n/backend/simple'

puts '1'
module I18n
  module Base
    module Thread
      def self.current
        @current ||= {}
      end
    end
  end
end

puts '2'
require 'mumukit/core'
require 'mumukit/core/i18n'

puts '3'

__dir__  = File.dirname(File.realpath(__FILE__))
#sI18n.load_translations_path File.join(__dir__, '..', 'locales', '*.yml')

puts '4'

require_relative '../mumukit/inspection/version'

module Mumukit
  class Inspection
    attr_accessor :type, :target, :negated
    alias negated? negated

    def initialize(type, target, negated=false)
      @type = type
      @target = target
      @negated = negated
    end

    def to_s
      "#{negated_to_s}#{type}#{target_to_s}"
    end

    def negated_to_s
      negated ? 'Not:' : nil
    end

    def target_to_s
      target ? ":#{target.to_s}" : nil
    end

    def self.parse_binding_name(binding_s)
      if binding_s.start_with? 'Intransitive:'
        binding_s[13..-1]
      else
        binding_s
      end
    end

    def self.parse(insepection_s)
      raise "Invalid inspection #{insepection_s}" unless insepection_s =~ /^(Not\:)?([^\:]+)\:?(.+)?$/
      Inspection.new($2, Mumukit::Inspection::Target.parse($3), $1.present?)
    end
  end
end

require_relative '../mumukit/inspection/target'
require_relative '../mumukit/inspection/expectation'
require_relative '../mumukit/inspection/i18n'
