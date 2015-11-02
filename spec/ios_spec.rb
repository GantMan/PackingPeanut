describe App::Persistence do

  after do
    App::Persistence.delete_all!
  end

  describe '.app_key' do

    it "caches the @app_key" do
      App::Persistence.instance_variable_get(:@app_key).should.equal nil
      App::Persistence.app_key
      App::Persistence.instance_variable_get(:@app_key).should.not.equal nil
    end

    it 'delegates to App::App.idenfitier' do
      App::Persistence.app_key.should == NSBundle.mainBundle.bundleIdentifier
    end

  end


  describe "storing objects" do
    it 'can persist simple objects' do
      lambda do
        App::Persistence['arbitraryNumber'] = 42
      end.
        should.not.raise(Exception)
    end

    it "must call synchronize" do
      storage = NSUserDefaults.standardUserDefaults
      def storage.synchronize; @sync_was_called = true; end

      App::Persistence['arbitraryNumber'] = 42
      storage.instance_variable_get(:@sync_was_called).should.equal true
    end
  end

  describe "storing multiple objects" do
    it 'can persist multiple objects' do
      lambda do
        App::Persistence.merge({
          :anotherArbitraryNumber => 9001,
          :arbitraryString => 'test string'
        })
      end.
        should.not.raise(Exception)
    end

    it 'must call synchronize' do
      storage = NSUserDefaults.standardUserDefaults
      def storage.synchronize; @sync_was_called = true; end

      App::Persistence.merge({
        :anotherArbitraryNumber => 9001,
        :arbitraryString => 'test string'
      })
      storage.instance_variable_get(:@sync_was_called).should.equal true
    end
  end

  describe "retrieving objects" do
    before do
      App::Persistence["arbitraryNumber"] = 42
      App::Persistence[:arbitraryString] = 'test string'
    end

    it 'can retrieve persisted objects' do
      App::Persistence['arbitraryNumber'].should == 42
      App::Persistence[:arbitraryString].should == 'test string'
    end

    it 'returns fully functional strings' do
      App::Persistence[:arbitraryString].methods.should == 'test string'.methods
    end
  end

  describe "retrieving all objects" do
    before do
      App::Persistence["arbitraryNumber"] = 42
      App::Persistence[:anotherArbitraryNumber] = 9001
      App::Persistence[:arbitraryString] = 'test string'
    end

    it 'can retrieve a dictionary of all objects' do
      all = App::Persistence.all
      all.is_a?(Hash).should == true

      compare_to = {}
      compare_to["anotherArbitraryNumber"] = 9001
      compare_to["arbitraryNumber"]        = 42
      compare_to["arbitraryString"]        = "test string"

      all.should == compare_to
    end
  end

  describe "deleting object" do
    before do
      App::Persistence['arbitraryString'] = 'foobarbaz'
    end

    it 'can delete persisted object' do
      App::Persistence.delete(:arbitraryString).should == 'foobarbaz'
      App::Persistence['arbitraryString'].should.equal nil
    end

    it 'returns nil when the object does not exist' do
      App::Persistence.delete(:wrongKey).should == nil
    end

    it 'must call synchronize' do
      storage = NSUserDefaults.standardUserDefaults
      def storage.synchronize; @sync_was_called = true; end

      App::Persistence.delete(:arbitraryString)

      storage.instance_variable_get(:@sync_was_called).should.equal true
    end

  end

  describe "deleting everything!" do
    before do
      App::Persistence.delete_all!
      App::Persistence['arbitraryString'] = 'foobarbaz'
      App::Persistence[:my_prefs] = [1, 2, 3, 4, "five"]
    end

    it 'should have two preferences' do
      App::Persistence['arbitraryString'].should == 'foobarbaz'
      App::Persistence[:my_prefs].should  == [1, 2, 3, 4, "five"]
    end

    it 'should delete everything' do
      App::Persistence.all.count.should == 2
      App::Persistence.delete_all!
      App::Persistence.all.count.should == 0
    end

    it 'should only call synchronize once at the end' do
      storage = NSUserDefaults.standardUserDefaults
      def storage.synchronize
        @sync_called ||= 0
        @sync_called = @sync_called + 1
      end

      App::Persistence.delete_all!

      storage.instance_variable_get(:@sync_called).should.equal 1
    end

  end


  describe "altenate names" do
    it 'can be referred to via PP' do
      App::Persistence.should.equal PackingPeanut
      PP.should.equal PackingPeanut
    end
  end
end
