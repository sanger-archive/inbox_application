# frozen_string_literal: true
require_relative '../validators/hash_schema_validator'

class Checkpoint < ApplicationRecord

  UnknownComparison = Class.new(StandardError)

  ENTRY = 'entry'
  EXIT = 'exit'

  DIRECTIONS = [ENTRY,EXIT].freeze

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

  scope :entry, ->() { where(direction:ENTRY ) }
  scope :exit,  ->() { where(direction:EXIT  ) }

  def check(message)
    processor(message).check
  end

  def process(message)
    processor(message).process
  end

  def processor(message)
    processor_class.new(self,message)
  end

  def metadata
    self.conditions ||= {}
    conditions[:metadata]
  end

  def metadata=(value)
    self.conditions ||= {}
    conditions[:metadata]= value
  end

  [:primary_details,:secondary_details,:primary_associations,:secondary_associations].each do |field|
    define_method(field) do
      self.conditions ||= {}
      conditions.fetch(field,[])
    end
    define_method("#{field}=") do |value|
      self.conditions ||= {}
      conditions[field] = value
    end
    define_method("each_#{field.to_s.singularize}") do |&block|
      self.conditions ||= {}
      conditions.fetch(field,[]).each(&block)
    end
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
