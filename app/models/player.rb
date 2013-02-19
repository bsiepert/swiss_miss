class Player < ActiveRecord::Base
  has_many :registrations
  has_many :events, :through => :registrations
  attr_accessible :dci_number, :first_name, :last_name

  def name
    "#{first_name} #{last_name}"
  end
end
