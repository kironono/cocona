class ReserveRule < ApplicationRecord

  validates :condition, presence: true
  validate :check_condition

  def check_condition
    begin
      d = JSON.parse(condition, {symbolize_names: true})
    rescue JSON::ParserError => e
      errors.add(:condition, e.message)
    end
    if d.size < 1
      errors.add(:condition, I18n.t('errors.messages.empty'))
    end
    d.each do |node|
      errors.add(:condition, I18n.t('errors.messages.invalid')) unless node[:value].present?
    end
  end

  def conditions
    d = condition_obj
    conds = {}
    d.each_with_index do |c, index|
      conds[index.to_s] = {"#{c[:attr]}_#{c[:cond]}": c[:value]}
    end
    return conds
  end

  def condition_obj
    return JSON.parse(condition, {symbolize_names: true})
  end

end
