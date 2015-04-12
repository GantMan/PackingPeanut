
# Potential fixes for type specifics
# Super fix #1 ->   Serialize it: http://stackoverflow.com/questions/7057845/save-arraylist-to-sharedpreferences
# ObjectSerializer: https://github.com/apache/pig/blob/89c2e8e76c68d0d0abe6a36b4e08ddc56979796f/src/org/apache/pig/impl/util/ObjectSerializer.java
# Super fix #2 ->   Store depending on the class and retrieve with either
# A: Failover defaults calling methods
# B: Grab ALL data, and use that hash
# Super fix #3 ->  Serialize with JSON
# new Gson().toJson(obj)
# And for deserialization,

# new Gson().fromJson(jsonStr, MyClass.class);
# http://stackoverflow.com/questions/7346786/json-on-android-serialization

module App
  module Persistence

    MODE_PRIVATE = 0
    MODE_WORLD_READABLE = 1
    MODE_WORLD_WRITEABLE = 2
    MODE_MULTI_PROCESS = 4

    PREFERENCE_MODES = {
      private: MODE_PRIVATE,
      readable: MODE_WORLD_READABLE,
      world_readable: MODE_WORLD_READABLE,
      writable: MODE_WORLD_WRITEABLE,
      world_writable: MODE_WORLD_WRITEABLE,
      multi: MODE_MULTI_PROCESS,
      multi_process: MODE_MULTI_PROCESS
    }

    module_function

    def []=(key, value)
      settings = get_settings
      editor = settings.edit
      editor.putString(key, value)
      editor.commit 
    end

    def [](key)
      get_value key
    end

    def get_value key
      settings = get_settings
      value = settings.getString(key,nil)
    end

    def storage_file=(value)
      @persistence_storage_file = value
    end

    def storage_file
      @persistence_storage_file ||= "default_persistence_file"
    end

    def preference_mode=(value)
      @current_preference_mode = PREFERENCE_MODES[value] || value
    end

    def preference_mode
      @current_preference_mode ||= MODE_PRIVATE
    end

    def all
      settings = get_settings
      settings.getAll
    end

    def get_settings
      current_context.getSharedPreferences(storage_file, preference_mode)
    end

    # Allows us to use this from anywhere by setting the context
    # Useful when you want to access this module from the REPL
    def current_context
      @context || getApplicationContext
    end

    # attr_accessor is not supported for modules in RMAndroid... yet.
    def context= supplied_context 
      @context = supplied_context
    end

  end
end

PP = App
