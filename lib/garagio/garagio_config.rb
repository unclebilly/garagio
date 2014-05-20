class GaragioConfig
  def self.[](key)
    key = key.to_s
    config[key] || ENV[key.upcase]
  end

  def self.config
    @config ||= YAML.load_file(File.expand_path("../../../config/config.yml", __FILE__))
  end
end