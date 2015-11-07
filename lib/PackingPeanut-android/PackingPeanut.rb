module PackingPeanut

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
    # Let's play nice with strings and non-strings
    string_key = key.to_s
    settings = get_settings
    editor = settings.edit
    json = serialize(string_key,value)
    editor.putString(string_key, json.toString)
    editor.commit
  end

  def [](key)
    # Let's play nice with strings and non-strings
    string_key = key.to_s
    json_string = get_value(string_key)
    return nil if json_string == ""
    deserialize(string_key, json_string)
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
    all_hashes = settings.getAll.map { |key, value| Moran.parse(value) }

    # Currently an array of hashes, needs to be one big hash
    merged_hashes = {}
    all_hashes.each do |h|
      merged_hashes = merged_hashes.merge(h)
    end

    merged_hashes
  end

  def delete(key)
    settings = get_settings
    string_key = key.to_s
    editor = settings.edit
    editor.remove(string_key)
    editor.commit
  end

  def delete_all!
    settings = get_settings
    editor = settings.edit
    editor.clear()
    editor.commit
  end

  def get_settings
    raise "[PackingPeanut] Fatal Error - You must set the context before accessing persistent data." unless @context
    current_context.getSharedPreferences(storage_file, preference_mode)
  end

  # Allows us to use this from anywhere by setting the context
  # Useful when you want to access this module from the REPL
  def current_context
    # THIS SHOULD HAVE SAFE FAILOVERS
    # BUT defined? is causing erros in RMA native methods as of this commit
    @context
  end

  # attr_accessor is not supported for modules in RMAndroid... yet.
  def context= supplied_context
    @context = supplied_context
  end

end

# delicious PP shortcut
PP = PackingPeanut unless defined? PP

# Bubblewrap syntax
module App
  Persistence = PackingPeanut unless defined? App::Persistence
end
