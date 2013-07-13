PROJECTNAME = 'STURLEncoding'.freeze

task :default => 'test'

namespace :test do
	desc "Execute #{PROJECTNAME}Tests-iOS"
	task :ios do
		buildargs = [
			'-project', "#{PROJECTNAME}.xcodeproj",
			'-scheme', "#{PROJECTNAME}-iOS",
			'-sdk', 'iphonesimulator',
		]
		testargs = [
			'parallelize',
		]
		$success_ios = system('xctool', *(buildargs + [ 'test', *testargs ]))
	end

	desc "Execute #{PROJECTNAME}Tests-mac"
	task :mac do
		buildargs = [
			'-project', "#{PROJECTNAME}.xcodeproj",
			'-scheme', "#{PROJECTNAME}-mac",
			'-sdk', 'macosx',
		]
		testargs = [
			'parallelize',
		]
		$success_mac = system('xctool', *(buildargs + [ 'test', *testargs ]))
	end
end

desc "Execute #{PROJECTNAME}Tests-iOS and -mac"
task :test => ['test:ios', 'test:mac'] do
	exit 1 unless $success_ios
	exit 1 unless $success_mac
end
