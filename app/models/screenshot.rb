class Screenshot
  include Mongoid::Document
  include Mongoid::Paperclip

  embedded_in :ticket

  has_mongoid_attached_file :image
end
