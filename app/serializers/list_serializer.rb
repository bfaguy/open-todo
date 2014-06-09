class ListSerializer < ActiveModel::Serializer
  attributes :id, :name, :permissions
  has_many :items
end
