require 'spec_helper'
describe 'servidor_controle_remoto_ir' do
  context 'with default values for all parameters' do
    it { should contain_class('servidor_controle_remoto_ir') }
  end
end
