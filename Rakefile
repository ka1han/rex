# encoding: utf-8

require 'fileutils'
 
task :build => :update do
	Rake::Task['clean'].execute
	puts "[*] Building librex.gemspec"
  system "gem build librex.gemspec &> /dev/null"
end
 
task :release => :build do
	puts "[*] Pushing librex to rubygems.org"
  system "gem push librex-*.gem &> /dev/null"
	Rake::Task['clean'].execute
end

task :clean do
	system "rm *.gem &> /dev/null"
end

task :update do
	puts "[*] Removing old Rex code..."
	system "git rm -rf lib/ >/dev/null 2>&1"
	::FileUtils.rm_rf("lib")
	::FileUtils.mkdir("lib")

	
	tdir = "tmp" + rand(0x100000000).to_s + rand(0x100000000).to_s 
	
	puts "[*] Checking out Metasploit trunk..."
	results = `svn co https://www.metasploit.com/svn/framework3/trunk/lib/ #{tdir}`
	rev = results.match(/^Checked out revision (.*)\.$/)
	puts "[*] Checkout Revision: #{rev[1]}"
	
	puts "[*] Purging SVN directories..."
	system("find #{tdir} -name .svn | xargs -i rm -rf {}")
	
	
	puts "[*] Copying new files..."
	::FileUtils.cp( ::File.join(tdir, "rex.rb"), "lib")
	::FileUtils.cp_r( ::File.join(tdir, "rex"), ::File.join("lib", "rex") )
	
	system "git add lib/ &> /dev/null"

	puts "[*] Cleaning up tmp files..."	
	::FileUtils.rm_rf(tdir)
	
	version = ""
	
	print "[*] Updating librex.gemspec with new Version and Revision Number v"
	File.open("librex.gemspec.1", "w+") do |output|
		File.open("librex.gemspec", "r") do |input|
			while (line = input.gets)
				
				if line =~ /^VERSION = (.*)$/
					version = $1.chop.gsub("\"",'').split(".")
					version[2] = version[2].to_i + 1
					version = version.join(".")
					
					print "#{version}\n"
						
					line = "VERSION = \"#{version}\"\n"
				elsif line =~ /^REVISION = (.*)$/
					line = "REVISION = \"#{rev[1]}\"\n"
				else
					line = line
				end
			
				output.write line
			end
		end
	end
	
	system "mv librex.gemspec.1 librex.gemspec"
	
	puts "[*] Updating README.markdown with new Revision Number"
	File.open("README.markdown.1", "w+") do |output|
		File.open("README.markdown", "r") do |input|
			while (line = input.gets)						
				if line =~ /^SVN Revision: (.*)$/
					line = "SVN Revision: #{rev[1]}\n"
				else
					line = line
				end
			
				output.write line
			end
		end
	end
	
	system "mv README.markdown.1 README.markdown &> /dev/null"
	
	system "git commit -a -m \"Updated for Revision #{rev[1]}\" &> /dev/null"
	puts "[*] Commiting and Pushing Updates for Revision #{rev[1]}"
	system "git push &> /dev/null"
	
	#Twitter tweet for the update, I am that lazy yes.
	puts "[*] Updated librex to v#{version} based on SVN Revision: #{rev[1]} of the #metasploit rex library. Available in rubygems."
end
