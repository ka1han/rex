# encoding: utf-8

APP_NAME = "librex"
VERSION = "0.0.63"
REVISION = "14187"

Gem::Specification.new do |s|
	s.name									= APP_NAME
	s.version								= VERSION
	s.homepage								= "http://www.metasploit.com/"
	s.summary								= "Ruby Exploitation Library"
	s.description							= "Rex provides a variety of classes useful for security testing and exploit development. Based on SVN Revision #{REVISION}"
	s.license								= "BSD"
	
	s.authors								= ["HD Moore", "Jacob Hammack"]
	s.email									= ["hd_moore@rapid7.com", "jacob.hammack@hammackj.com"]
	
	s.files									= Dir['[A-Z]*'] + Dir['lib/**/*']
	s.require_paths							= ["lib"]
	s.extra_rdoc_files						= ["README.markdown"]
	s.required_ruby_version 				= ">= 1.8.7"
	s.platform 								= "ruby"
end
