class LeaveRequest < ApplicationRecord
  belongs_to :user

  # The status & leave_type field should be an enum, however the free DB provides rendering and generates conflicts
  validates :start_date, :end_date, presence: true
  validate :end_date_after_start_date
  validate :no_overlap, on: :create

  def duration
    (end_date - start_date).to_i + 1
  end

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    errors.add(:end_date, 'debe ser posterior a la fecha de inicio') if end_date < start_date
  end

  def no_overlap
    overlapping_requests = LeaveRequest
                             .where(user_id:)
                             .where('start_date <= ? AND end_date >= ?', end_date, start_date)
                             .where(status: 'aprobado')
    errors.add(:base, 'El periodo se solapa con otra solicitud que fue aprobada') if overlapping_requests.exists?
  end
end
