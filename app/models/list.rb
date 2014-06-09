class List < ActiveRecord::Base
  belongs_to :user
  has_many :items

#  attr_protected :permissions


  validates :user_id,
            :uniqueness => {:scope => :name, :message => "List name already exists"}


  def self.permission_options
    %w(private viewable open)
  end

  def list_open?
    self.permissions == "open"
  end

  def permissions_editable?(current_user)
    self.user == current_user

  end

  def add(item_description)
    if items.create(description: item_description)
      true
    else
      false
    end
  end

  def remove(item_description)
    if item = items.find_by(description: item_description)
      item.mark_complete
    else
      false
    end
  end

end
