# frozen_string_literal: true
require_relative '../validators/hash_schema_validator'

class Checkpoint < ApplicationRecord

  UnknownComparison = Class.new(StandardError)

  DIRECTIONS = ['entry','exit'].freeze

  serialize :conditions

  belongs_to :inbox, inverse_of: :checkpoints
  validates :event_type, presence: true
  validates :subject_role, presence: true
  validates :direction, presence: true, inclusion:   { in: DIRECTIONS }
  validates :conditions, presence: true, hash_schema: { schema: {
    metadata: Hash,
    primary_details: Array,
    secondary_details: Array,
    primary_associations: Array,
    secondary_associations: Array
  }}

  def check(message)
    processor(message).check
  end

  def process(message)
    processor(message).process
  end

  def processor(message)
    processor_class.new(self,message)
  end

  private

  def processor_class
    case direction
    when 'entry'
      Checkpoint::EntryProcessor
    when 'exit'
      Checkpoint::ExitProcessor
    else
      raise ActiveRecord::RecordInvalid, self
    end
  end
end
