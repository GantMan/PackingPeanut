# Persistence module built on top of NSUserDefaults
module App
  module Persistence
    module_function

    def app_key
      @app_key ||= NSBundle.mainBundle.bundleIdentifier
    end

    def storage_file
      @persistence_storage_file ||= "default_persistence_file"
    end

    def storage_file=(value)
      @persistence_storage_file = value
    end

    def []=(key, value)
      storage.setObject(value, forKey: storage_key(key))
      storage.synchronize
    end

    def [](key)
      value = storage.objectForKey storage_key(key)

      # RubyMotion currently has a bug where the strings returned from
      # standardUserDefaults are missing some methods (e.g. to_data).
      # And because the returned object is slightly different than a normal
      # String, we can't just use `value.is_a?(String)`
      value.class.to_s == 'String' ? value.dup : value
    end

    def merge(values)
      values.each do |key, value|
        storage.setObject(value, forKey: storage_key(key))
      end
      storage.synchronize
    end

    def delete(key)
      value = storage.objectForKey storage_key(key)
      storage.removeObjectForKey(storage_key(key))
      storage.synchronize
      value
    end

    def storage
      NSUserDefaults.standardUserDefaults
    end

    def storage_key(key)
      "#{app_key}_#{storage_file}_#{key}"
    end

    def all
      hash = storage.dictionaryRepresentation.select{|k,v| k.start_with?("#{app_key}_#{storage_file}") }
      new_hash = {}
      hash.each do |k,v|
        new_hash[k.sub("#{app_key}_#{storage_file}_", '')] = v
      end
      new_hash
    end
  end

end

# delicious shortcut
PP = App::Persistence unless defined? PP
