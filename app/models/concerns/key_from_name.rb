module KeyFromName

  def self.included(base)
    base.before_validation :generate_key, unless: :key?, if: :name?
    base.validates :key, presence: true, uniqueness: true
    base.validates :name, format: { with: /[a-zA-Z0-9]+/ }
  end

  def to_param; key; end

  def key
    super || generate_key
  end

  private

  # Note: This method does not guarantee a unique key, and is sensitive
  # to race conditions.
  def generate_key
    return nil unless name?
    candidate_key = name.parameterize
    clashing_keys = self.class.where(key:candidate_key).count
    if clashing_keys.zero?
      self.key = candidate_key
    else
      self.key = candidate_key << '-%i' % clashing_keys
    end
  end

end
