PROJECTNAME = 'STURLEncoding'.freeze

namespace :test do
	desc "Execute #{PROJECTNAME}Tests-iOS"
	task :ios do
		buildargs = [
			'-project', "#{PROJECTNAME}.xcodeproj",
			'-scheme', "#{PROJECTNAME}-iOS",
			'-sdk', 'iphonesimulator',
		]
		$success_ios = system('xctool', *(buildargs << 'test'))
	end

	desc "Execute #{PROJECTNAME}Tests-mac"
	task :mac do
		buildargs = [
			'-project', "#{PROJECTNAME}.xcodeproj",
			'-scheme', "#{PROJECTNAME}-mac",
			'-sdk', 'macosx',
		]
		$success_mac = system('xctool', *(buildargs << 'test'))
	end
end

desc "Execute #{PROJECTNAME}Tests-iOS and -mac"
task :test => ['test:ios', 'test:mac'] do
	exit 1 unless $success_ios
	exit 1 unless $success_mac
end

task :default => 'test'
