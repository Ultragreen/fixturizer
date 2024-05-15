RSpec.describe 'Test Fixturizer' do
   

  context 'Database : drop and populate' do
    
    it { expect(database).to be_correctly_dropped }
    it { expect(database).to be_correctly_populated  }
    
  end

    context 'Datasets : test fixturizing' do
      it { datasets.generate dataset: :set1  }
      
    end

end