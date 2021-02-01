# frozen_string_literal: true

# Class describing a Multi Value Dictionary where each key has a list of unique values
class MultiValueDictionary
  class DuplicateValueError < StandardError; end

  class KeyUnavailableError < StandardError; end

  class ValueUnavailableError < StandardError; end

  attr_accessor :dict

  def initialize
    @dict = {}
  end

  # Public - Adds a key, value pair to the dictionary.
  #          If the key has a non-empty list, it adds the new value to the list.
  #
  # key - A String specifying the input key
  # value - A String specifying input value
  #
  # Raise - DuplicateValueError if the value already exists in the list of values  for the key.
  def add(key, value)
    if dict[key]
      if dict[key].include?(value)
        raise DuplicateValueError,
              "'#{key}' includes '#{value}' in its collection of values."
      end

      dict[key] << value
    else
      dict[key] = [value]
    end
    dict[key]
  end

  # Public - Removes a value from the values for the Key. Also removes the key from dictionary
  #          if it has an emtpy list of values after removing input value.
  #
  # key - A String specifying the input key
  # value - A String specifying input value
  #
  # Raises - KeyUnavailableError if the key doesn't exist in the dictionary.
  #        - ValueUnavailableError if the Value doesn't exist in the dictionary.
  def remove(key, value)
    raise KeyUnavailableError, "'#{key}' doesn't exist in the dictionary." unless dict[key]

    raise ValueUnavailableError, "'#{key}' doesn't include '#{value}' in its values." unless dict[key].include?(value)

    dict[key].delete(value)
    dict.delete(key) if dict[key].empty?
    dict[key]
  end

  # Public - Lists all the values corresponding to an input key.
  #
  # key - A String specifying the input key
  #
  # Raises - KeyUnavailableError if the key doesn't exist in the dictionary.
  #
  # Returns - A list of all values corresponding to the Key.
  def members(key)
    raise KeyUnavailableError, "'#{key}' doesn't exist in the dictionary." unless dict[key]

    dict[key]
  end

  # Public - Lists all the keys in the dictionary.
  #
  # Returns - A list of all keys in the dictionary.
  def keys
    dict.keys
  end

  # Public - Removes the key and all values corresponding to that key from dictionary.
  #
  # key - A String specifying the input key
  #
  # Raises - KeyUnavailableError if the key doesn't exist in the dictionary.
  def remove_all(key)
    raise KeyUnavailableError, "'#{key}' doesn't exist in the dictionary." unless dict[key]

    dict.delete(key)
    nil
  end

  # Public - Clears out all keys and values from the dictionary.
  def clear
    dict.clear
  end

  # Public - Checks for the presence of a key in the dictionary.
  #
  # key - A String specifying the input key
  #
  # Returns - True if the dictionary includes the input key. False otherwise.
  def key_exists?(key)
    dict.key?(key)
  end

  # Public - Checks for the presence of a value in the values for the key.
  #
  # key - A String specifying the input key
  # value - A String specifying input value
  #
  # Returns - True if the value is available in the values mapped to the key. False otherwise.
  def value_exists?(key, value)
    return false unless dict[key]

    dict[key].include?(value)
  end

  # Public - Lists all values from all keys in the dictionary.
  #
  # Returns - A list of all values in the dictionary.
  def all_members
    dict.values.flatten
  end

  # Public - Returns all key value pairs in the dictionary.
  #
  # Returns - List of all individual key value pairs added to the dictionary.
  def items
    items = []
    dict.each_key do |key|
      values = dict[key]
      values.each do |value|
        items.push({ key => value })
      end
    end

    items
  end
end
