class Pairing < ActiveRecord::Base
  has_many :participants
  has_many :messages, :through => :participants

end
