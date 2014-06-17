class Screenshot
  include Mongoid::Document
  include Mongoid::Paperclip

  embedded_in :ticket

  has_mongoid_attached_file :image

  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
