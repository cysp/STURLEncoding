namespace :test do
	desc 'Execute STURLEncodingTests-iOS'
	task :ios do
		buildargs = [
			'-project', 'STURLEncoding.xcodeproj',
			'-scheme', 'STURLEncoding-iOS',
			'-sdk', 'iphonesimulator',
		]
		$success_ios = system('xctool', *(buildargs << 'test'))
	end

	desc 'Execute STURLEncodingTests-mac'
	task :mac do
		buildargs = [
			'-project', 'STURLEncoding.xcodeproj',
			'-scheme', 'STURLEncoding-mac',
			'-sdk', 'macosx',
		]
		$success_mac = system('xctool', *(buildargs << 'test'))
	end
end

desc 'Execute STURLEncodingTests-iOS and -mac'
task :test => ['test:ios', 'test:mac'] do
	exit 1 unless $success_ios
	exit 1 unless $success_mac
end

task :default => 'test'
