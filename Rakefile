PROJECTNAME = 'STURLEncoding'.freeze

require 'json'
require 'open3'
require 'pathname'
require 'rest_client'

task :default => 'analyze'

desc "Clean #{PROJECTNAME}-iOS and -mac"
task :clean => [ 'ios', 'mac' ].map { |x| 'clean:' + x }

desc "Analyze #{PROJECTNAME}-iOS and -mac"
task :analyze => [ 'ios', 'mac' ].map { |x| 'analyze:' + x }

desc "Execute #{PROJECTNAME}Tests-iOS and -mac"
task :test => [ 'ios', 'mac' ].map { |x| 'test:' + x }

namespace :clean do
	desc "Clean #{PROJECTNAME}-iOS"
	task :ios do IosSim.clean or fail end

	desc "Clean #{PROJECTNAME}-mac"
	task :mac do Mac.clean or fail end
end

namespace :analyze do
	desc "Analyze #{PROJECTNAME}-iOS"
	task :ios do IosSim.analyze or fail end

	desc "Analyze #{PROJECTNAME}-mac"
	task :mac do Mac.analyze or fail end
end

namespace :test do
	desc "Execute #{PROJECTNAME}Tests-iOS"
	task :ios do IosSim.test or fail end

	desc "Execute #{PROJECTNAME}Tests-mac"
	task :mac do Mac.test or fail end
end

namespace :coveralls do
	desc "Submit coverage data to coveralls -iOS"
	task :ios do IosSim.coveralls or fail end

	desc "Submit coverage data to coveralls -mac"
	task :mac do Mac.coveralls or fail end
end


module BuildCommands
	def clean
		system('xctool', *(@BUILDARGS + [ 'clean' ]))
	end

	def analyze
		analyzeargs = [
			'-failOnWarnings',
		]
		system('xctool', *(@BUILDARGS + [ 'analyze', *analyzeargs ]))
	end

	def test
		buildargs = @BUILDARGS + [
			'-configuration', 'Coverage',
		]
		testargs = [
			#'parallelize',
		]
		system('xctool', *(buildargs + [ 'test', *testargs ]))
	end

	def coveralls
		coveralls_data = {}
		if ENV['COVERALLS_REPO_TOKEN']
			coveralls_data[:repo_token] = ENV['COVERALLS_REPO_TOKEN']
		elsif ENV['TRAVIS']
			coveralls_data[:service_name] = 'travis-ci'
			coveralls_data[:service_job_id] = ENV['TRAVIS_JOB_ID']
		end

		if !coveralls_data.fetch(:repo_token, "").empty?
		elsif !coveralls_data.fetch(:service_name, "").empty? && !coveralls_data.fetch(:service_job_id, "").empty?
		else
			STDERR.puts 'Unable to determine coveralls configuration'
			return 1
		end

		object_file_path = Pathname.new find_object_file_dir
		gcfilenames = []
		object_file_path.each_child do |c|
			gcfilenames << c.cleanpath if c.fnmatch? '*'
		end

		coverage = {}
		Open3.popen3('STCoverage', *(gcfilenames.map {|p| p.to_s})) do |stdin, stdout, stderr|
			coverage_json = stdout.read
			coverage_json.chomp!
			coverage = JSON.parse(coverage_json) unless coverage_json.empty?
		end

		cwd = Pathname.getwd
		cwds = cwd.to_s

		coveralls_source_files = []
		coverage.each do |k, v|
			next unless k.start_with? cwds

			path = Pathname.new k
			next unless path.file? && path.readable?

			relpath = path.relative_path_from cwd
			source = path.readlines
			sourcecoverage = v
			sourcecoverage << nil while sourcecoverage.length < source.length

			coveralls_source_file = {}
			coveralls_source_file[:name] = relpath.to_s
			coveralls_source_file[:source] = source.join ''
			coveralls_source_file[:coverage] = sourcecoverage
			coveralls_source_files << coveralls_source_file
		end

		coveralls_git = coveralls_gitinfo
		coveralls_data[:git] = coveralls_git unless coveralls_git.empty?
		coveralls_data[:source_files] = coveralls_source_files

		coveralls_json = JSON.generate coveralls_data

		json_file = JSONFileStringIO.new coveralls_json, 'r'
		json_file.path = 'json_file'

		success = false
		RestClient.post 'https://coveralls.io/api/v1/jobs', { :json_file => json_file, :multipart => true } do |response, request, result|
			case response.code
			when 200
				success = true
			end
		end
		!success
	end

	private
	def find_object_file_dir
		buildsettings = xcode_buildsettings
		variant = buildsettings['CURRENT_VARIANT']
		dir = buildsettings["OBJECT_FILE_DIR_#{variant}"] || buildsettings['OBJECT_FILE_DIR']
		return nil if dir.nil?
		dir << '/' + buildsettings['PLATFORM_PREFERRED_ARCH'].to_s
	end

	def xcode_buildsettings(target = nil)
		if target.nil?
			accum = XcodeFirstBuildableBuildSettingsAccumulator.new
		else
			accum = XcodeSpecificTargetBuildSettingsAccumulator.new target
		end

		buildargs = @BUILDARGS + [
			'-configuration', 'Coverage',
		]
		Open3.popen3('xctool', *(buildargs + [ '-showBuildSettings' ])) do |stdin, stdout, stderr|
			while stdout.gets
				accum.add_line $_.chomp
			end
		end

		accum.buildsettings
	end

	def coveralls_gitinfo
		gitinfo = { }

		gitinfohead = { }
		gitargs = [
			'log',
			'-n', '1',
			"--format=format:%H\n%ae\n%aN\n%ce\n%cN\n%s",
		]
		Open3.popen3('git', *gitargs) do |stdin, stdout, stderr|
			[ :id, :author_email, :author_name, :committer_email, :committer_name, :message ].each do |x|
				value = stdout.gets
				value = value.chomp unless value.nil?
				gitinfohead[x] = value unless value.nil? or value.empty?
			end
		end
		gitinfo[:head] = gitinfohead unless gitinfohead.empty?

		gitbranch = nil
		Open3.popen3('git', *[ 'rev-parse', '--abbrev-ref=strict', 'HEAD' ]) do |stdin, stdout, stderr|
			value = stdout.gets
			value = value.chomp unless value.nil?
			gitbranch = value unless value.nil? or value.empty?
		end
		gitinfo[:branch] = gitbranch unless gitbranch.nil?

		gitinfo
	end
end

class IosSim
	@BUILDARGS = [
		'-project', "#{PROJECTNAME}.xcodeproj",
		'-scheme', "#{PROJECTNAME}-iOS",
		'-sdk', 'iphonesimulator',
		'ONLY_ACTIVE_ARCH=NO',
	].freeze

	extend BuildCommands
end

class Mac
	@BUILDARGS = [
		'-project', "#{PROJECTNAME}.xcodeproj",
		'-scheme', "#{PROJECTNAME}-mac",
		'-sdk', 'macosx',
	].freeze

	extend BuildCommands
end


class XcodeFirstBuildableBuildSettingsAccumulator
	def initialize
		@have_armed = @armed = false
		@cliregexp = /^Build settings from command line:$/
		@regexp = /^Build settings for action build/
		@buildsettings = { }
	end

	def add_line(line)
		line.chomp!

		if line.empty?
			@armed = false
		elsif @cliregexp.match line
			@armed = true
		elsif @have_armed
		elsif @regexp.match line
			@have_armed = @armed = true
		end

		return unless @armed

		/\s*(\w+)\s*=\s*(.*)/.match line do |m|
			k, v = m[1], m[2]
			@buildsettings[k] = v
		end
	end

	attr_reader :buildsettings
end

class XcodeSpecificTargetBuildSettingsAccumulator
	def initialize(target)
		@armed = false
		@cliregexp = /^Build settings from command line:$/
		@regexp = /^Build settings for action build and target #{Regexp.quote(target.to_s)}:$/
		@buildsettings = { }
	end

	def add_line(line)
		line.chomp!

		if line.empty?
			@armed = false
		elsif @cliregexp.match line
			@armed = true
		elsif @regexp.match line
			@armed = true
		end

		return unless @armed

		/\s*(\w+)\s*=\s*(.*)/.match line do |m|
			k, v = m[1], m[2]
			@buildsettings[k] = v
		end
	end

	attr_reader :buildsettings
end

class JSONFileStringIO < StringIO
	def content_type
		'application/json'
	end
	attr_accessor :path
end
