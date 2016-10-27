desc "create VERSION, Use MAJOR_VERSION, MINOR_VERSION to override defaults"
task :create_version do
  version_file = "#{Rails.root}/config/initializers/version.rb"
  major = ENV["MAJOR_VERSION"] || 0
  minor = ENV["MINOR_VERSION"] || 0
  version_string = "VERSION = '#{major.to_s}.#{minor.to_s}'\n"
  File.open(version_file, "w") {|f| f.print(version_string)}
  $stderr.print(version_string)
end
