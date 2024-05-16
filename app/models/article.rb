class Article < ApplicationRecord
  include Visible

  has_many :comments, dependent: :destroy
  belongs_to :user

  has_one_attached :image
  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }

  attribute :reports_count, :integer, default: 0
  after_update :archive_if_reports_exceeded

  def report
    increment!(:reports_count)
  end

  private

  def archive_if_reports_exceeded
    if reports_count >= 3 && !archived?
      puts "Article #{id} is being archived due to reports_count: #{reports_count}"
      update(archived: true)
    end
  end

end
