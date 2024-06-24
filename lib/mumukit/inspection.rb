require 'mulang'

I18n.load_translations_path File.join(__dir__, 'locales', '*.yml')

module Mumukit
  module Inspection
    module Extension
      def new_inspection(match)
        if match
          Mulang::Inspection.new match['type'],
                                 new_target(match),
                                 negated: match.names.include?('negation') && match['negation'].present?,
                                 i18n_namespace: 'mumukit.inspection'
        end
      end

      def new_target(match)
        Mulang::Inspection::Target.new(:unknown, match['target']) if match.names.include?('target')
      end
    end

    module Css
      extend Mumukit::Inspection::Extension

      REGEXP = /^(?<negation>Not:)?(?<type>DeclaresStyle|DeclaresTag):(?<target>.*)$/

      def self.parse(inspection_s)
        new_inspection REGEXP.match(inspection_s)
      end
    end

    module Html
      extend Mumukit::Inspection::Extension

      REGEXP = /^(?<negation>Not:)?(?<type>DeclaresAttribute):(?<target>(href|src)=.*)$/

      def self.parse(inspection_s)
        new_inspection REGEXP.match(inspection_s)
      end
    end

    module Source
      extend Mumukit::Inspection::Extension

      REGEXP = /^(?<negation>Not:)?(?<type>SourceRepeats|SourceContains|SourceEquals|SourceEqualsIgnoreSpaces):(?<target>.*)$/

      def self.parse(inspection_s)
        new_inspection REGEXP.match(inspection_s)
      end
    end

    module JavaScript
      extend Mumukit::Inspection::Extension

      REGEXP = /^(?<type>JavaScript#LacksOfEndingSemicolon)$/

      def self.parse(inspection_s)
        new_inspection REGEXP.match(inspection_s)
      end
    end
  end
end
