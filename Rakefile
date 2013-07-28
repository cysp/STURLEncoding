PROJECTNAME = 'STURLEncoding'.freeze

require 'open3'
require 'pathname'
require 'stcoverage'
require 'stcoveralls'

task :default => 'analyze'

desc "Clean #{PROJECTNAME}-iOS and -mac"
task :clean => [ 'ios', 'mac' ].map { |x| 'clean:' + x }

desc "Analyze #{PROJECTNAME}-iOS and -mac"
task :analyze => [ 'ios', 'mac' ].map { |x| 'analyze:' + x }

desc "Execute #{PROJECTNAME}Tests-iOS and -mac"
task :test => [ 'ios', 'mac' ].map { |x| 'test:' + x }

desc "Calculate test coverage for #{PROJECTNAME}-iOS and -mac"
task :coverage => [ 'ios', 'mac' ].map { |x| 'coverage:' + x }

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

namespace :coverage do
	desc "Calculate test coverage -iOS"
	task :ios do IosSim.coverage or fail end

	desc "Calculate test coverage -iOS"
	task :mac do Mac.coverage or fail end
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

	def coverage
		cwd = Pathname.getwd
		cwds = cwd.to_s

		coverage = stcoverage

		source_lines = 0
		covered_lines = 0
		coverage.each do |k, v|
			next unless k.start_with? cwds

			path = Pathname.new k
			next unless path.file? && path.readable?

			relpath = path.relative_path_from cwd

			file_source_lines = v.count
			file_covered_lines = v.count {|k, v| v > 0}
			file_coverage_fraction = (file_covered_lines / file_source_lines.to_f unless file_source_lines == 0) || 0
			puts "#{relpath.to_s}: #{file_covered_lines}/#{file_source_lines} #{(file_coverage_fraction * 100).floor}%"

			source_lines += file_source_lines
			covered_lines += file_covered_lines
		end

		coverage_fraction = (covered_lines / source_lines.to_f unless source_lines == 0) || 0
		puts "Overall: #{(coverage_fraction * 100).floor}%"
		true
	end

	def coveralls
		cov = stcoverage
		Stcoveralls.coveralls do |c|
			c.add_stcoverage_local(cov)
		end
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

	def stcoverage
		object_file_path = Pathname.new(find_object_file_dir)
		return {} unless object_file_path.exist?

		gcfilenames = object_file_path.children.map{ |c| c.cleanpath.to_s if c.fnmatch? '*.gc??' }.compact
		Stcoverage.coverage(gcfilenames)
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
