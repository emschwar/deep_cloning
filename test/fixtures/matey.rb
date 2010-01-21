class Matey < ActiveRecord::Base
  belongs_to :pirate
  belongs_to :parent, :class_name => "Matey"
end
