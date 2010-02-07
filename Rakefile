port = 4567
 
@config = Hash.new
@config[:author] = "Thiago Moretto"
@config[:ext] = "txt"

desc "Prepare new article"
task :new do
  article = {'title' => nil, 'date' => Time.now.strftime("%d/%m/%Y"), 'author' => @config[:author]}.to_yaml
  article << "\n"
  article << "Once upon a time...\n\n"

  path = "articles/#{Time.now.strftime("%Y-%m-%d")}.#{@config[:ext]}"

  unless File.exist? path
      File.open(path, "w") do |file|
        file.write article
      end
      puts "an article was created for you at #{path}."
  else
      puts "I can't create the article, #{path} already exists."
  end
end

desc "Publish on Heroku"
task :publish do
	puts "Publishing on Heroku"
	system "git push heroku master"
end

desc "Start the app server"
task :start => :stop do
	puts "Starting the blog"
	system "ruby main.rb -p #{port} > access.log 2>&1 &"
end

# code lifted from rush
def process_alive(pid)
	::Process.kill(0, pid)
	true
rescue Errno::ESRCH
	false
end

def kill_process(pid)
	::Process.kill('TERM', pid)

	5.times do
		return if !process_alive(pid)
		sleep 0.5
		::Process.kill('TERM', pid) rescue nil
	end

	::Process.kill('KILL', pid) rescue nil
rescue Errno::ESRCH
end

desc "Stop the app server"
task :stop do
	m = `netstat -lptn | grep 0.0.0.0:#{port}`.match(/LISTEN\s*(\d+)/)
	if m
		pid = m[1].to_i
		puts "Killing old server #{pid}"
		kill_process(pid)
	end
end

