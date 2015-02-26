module EnvParsing

  def env_hash
    @env_hash ||= Hash.new.tap do |h|
      next if env.blank?

      env.lines.each do |line|
        key, val = line.split('=')
        h[key.strip] = val.strip if val.present?
      end
    end
  end

end
