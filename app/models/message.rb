class Message < ActiveRecord::Base
  belongs_to :participant
  has_one :pairing, :through => :participant
end
