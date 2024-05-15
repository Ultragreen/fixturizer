RSpec.describe 'Test Fixturizer' do
   

  context 'Database : drop and populate' do
    
    # it { database.drop }
    # it { database.populate }

    it { expect(database).to be_correctly_dropped }
    it { expect(database).to be_correctly_populated  }
    
    
  end

    context 'Datasets : test fixturizing' do
      it { datasets.generate dataset: :set1  }
      it { datasets.generate dataset: :set2  }
      it { datasets.generate dataset: :set3  }
      it { datasets.generate dataset: :set4  }
      it { datasets.generate dataset: :set5  }
      it { datasets.generate dataset: :set6  }
      
    end

end