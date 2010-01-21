class Pirate < ActiveRecord::Base
  has_many :mateys
  has_many :treasures
  has_many :gold_pieces, :through => :treasures
  has_one :parrot

  belongs_to :parent, :class_name => "Pirate"
end
