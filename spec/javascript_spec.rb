require_relative './spec_helper'

describe Mumukit::Inspection::JavaScript do
  before { Mulang::Inspection.register_extension! Mumukit::Inspection::JavaScript }
  after { Mulang::Inspection.unregister_extension! Mumukit::Inspection::JavaScript }

  describe 'parsing' do
    context 'JavaScript#LacksOfEndingSemicolon' do
      let(:inspection_s) { 'JavaScript#LacksOfEndingSemicolon' }

      it { expect(Mulang::Inspection.parse(inspection_s)).to json_like(type: 'JavaScript#LacksOfEndingSemicolon',
                                                                        negated: false,
                                                                        i18n_namespace: "mumukit.inspection") }
      it { expect(Mulang::Inspection.parse(inspection_s).to_s).to eq inspection_s }
    end
  end

  describe 'i18n' do
    before { I18n.locale = :es }

    describe 'source exectations' do
      it { expect(expectation('let x = 2', 'JavaScript#LacksOfEndingSemicolon').translate).to eq('la siguiente línea debería terminar en <code>;</code>: <pre><code>let x = 2</code></pre>') }
    end
  end
end
