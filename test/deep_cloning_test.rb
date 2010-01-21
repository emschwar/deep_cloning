require File.dirname(__FILE__) + '/teststrap'
require 'parrot'
require 'matey'
require 'gold_piece'
require 'treasure'
require 'pirate'
require 'deep_cloning'

require 'ruby-debug'
context "Deep Cloning" do
  setup do
    @jack = Pirate.new(:name => "Jack Sparrow",
                       :nick_name => "Captain Jack")
    @polly = @jack.build_parrot(:name => 'Polly')
    @jack.mateys.build(:name => "John")
    @jack.treasures.build(:found_at => "Isla del Muerte")
    @jack.treasures.first.gold_pieces.build
    @jack.save
  end

  context "setting the :previous_version_attr" do
    setup do
      @jack.clone(:include => :mateys,
                  :previous_version_attr => :parent)
    end

    should "set the :previous_version_attr to the thing being cloned" do
      topic.parent == @jack
    end

    should "set the :previous_version_attr on all included associations" do
      topic.mateys.map(&:parent).to_set ==
        @jack.mateys.to_set
    end
  end

  context "excluding a single attribute" do
    setup do
      @jack.clone(:except => :name)
    end

    should "not clone that attribute" do
      topic.name
    end.equals(nil)
  end
 
  context "excluding multiple attributes" do
    setup do
      @jack.clone(:except => [:name, :nick_name])
    end

    should "not clone any of the attributes" do
      topic.attributes.slice(:name, :nick_name).any?
    end.equals(false)
  end 

  context "including one association" do
    setup do
      @jack.clone(:include => :mateys)
    end

    should "have the same number of associated objects" do
      topic.mateys.size == @jack.mateys.size
    end
  end

  context "including more than one association" do
    setup do
      @jack.clone(:include => [:mateys, :treasures])
    end

    should "have the same number of objects in each association" do
      topic.mateys.size    == @jack.mateys.size and
      topic.treasures.size == @jack.treasures.size
    end
  end

  context "deep association includes" do
    setup do
      clone = @jack.clone(:include => {:treasures => :gold_pieces})
      clone.save && clone.reload
    end

    should "clone all the way down" do
      topic.treasures.size   == @jack.treasures.size and
      topic.gold_pieces.size == @jack.gold_pieces.size
    end
  end
  
  context "multiple deep association includes" do
    setup do
      clone = @jack.clone(:include => {:treasures => :gold_pieces, :mateys => {}})
      clone.save && clone.reload
    end

    should "clone all listed associations" do
      topic.treasures.size   == @jack.treasures.size and
      topic.gold_pieces.size == @jack.gold_pieces.size and
      topic.mateys.size      == @jack.mateys.size
    end
  end

  context "multiple deep associations specified with an array" do
    setup do
      clone = @jack.clone(:include => [{:treasures => :gold_pieces}, :mateys])
      clone.save && clone.reload
    end

    should "clone all listed associations" do
      topic.treasures.size   == @jack.treasures.size and
      topic.gold_pieces.size == @jack.gold_pieces.size and
      topic.mateys.size      == @jack.mateys.size
    end
    
  end

  context "deep copying a has_one association" do
    setup do
      clone = @jack.clone(:include => :parrot)
      clone.save && clone.reload
    end
    should "create a new object" do
      topic.parrot != @jack.parrot
    end 
  end
end
