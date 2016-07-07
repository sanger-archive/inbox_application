# Usage:
# validates :attribute, hash_schema: { schema:{
#     metadata: Hash,
#     primary_details: Array,
#     secondary_details: Array,
#     primary_associations: Array,
#     secondary_associations: Array
#   })
#}}
# Schema is a hash of accepted keys and their expected content
# Ensure the following is in your translation files:
# activerecord:
#   errors:
#     messages:
#       not_hash: is not a hash
#       unknown_key: has an unrecognised key
#       invalid_content: has a key with invalid content
class HashSchemaValidator < ActiveModel::EachValidator

  def validate_each(record,attribute,value)
    return record.errors.add(attribute,options[:message]||:not_hash) unless value.is_a?(Hash)
    return record.errors.add(attribute,options[:message]||:unknown_key) unless (value.keys - options[:schema].keys).empty?
    options[:schema].each do |key,type|
      next if value[key].nil? || value[key].is_a?(type)
      record.errors.add(attribute,options[:message]||:invalid_content)
    end
  end


end
