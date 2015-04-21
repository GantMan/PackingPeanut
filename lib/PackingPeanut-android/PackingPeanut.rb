module App
  module Persistence

    MODE_PRIVATE = 0
    MODE_WORLD_READABLE = 1
    MODE_WORLD_WRITEABLE = 2
    MODE_MULTI_PROCESS = 4

    JSONObject = Org::Json::JSONObject

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

    # Serialize key/value as json then
    # store that string with the settings key == json key
    def []=(key, value)
      settings = get_settings
      editor = settings.edit
      json = serialize(key,value)
      editor.putString(key, json.toString)
      editor.commit
    end

    def [](key)
      json_string = get_value(key)
      return json_string if json_string == ""
      deserialize(key, json_string)
    end

    def serialize(key, value)
      Moran.generate({:"#{key}" => value})
    end

    def deserialize(key, json_string)
      Moran.parse(json_string)[key]
    end

    def get_value key
      settings = get_settings
      settings.getString(key,nil)
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
      settings.getAll.map { |key, value| {key.to_sym => JSONObject.new(value).get(key)} }
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
