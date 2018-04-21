class Address < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :user_id, :locality, :street, :postal_code

end
