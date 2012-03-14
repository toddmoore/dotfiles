desc "Set up a Twitter Bootstrap project"
task :newtwitter => [:init] do
  `git clone https://github.com/twitter/bootstrap.git`
  `mv ./bootstrap/js/*.js ./js/`
  `mv ./bootstrap/img/* ./images/`
  `mv ./bootstrap/docs/assets/ico/* ./`
  `cd bootstrap/less && lessc bootstrap.less > ../../css/bootstrap.css`
  `sed -i '.old' 's@/img@/images@g' css/bootstrap.css && mv css/bootstrap.css css/bootstrap.css`
  `rm -rf bootstrap`
  `touch index.html`
  Rake::Task['gitinit'].invoke
end

desc "Set up an HTML5 Boilerplate project"
task :newhtml5 => [:init] do
  `rm -rf ./css`
  `rm -rf ./js`
  `git clone https://github.com/h5bp/html5-boilerplate.git`
  `mv ./html5-boilerplate/* ./`
  `mv ./html5-boilerplate/.gitattributes ./.gitattributes`
  `mv ./html5-boilerplate/.gitignore ./.gitignore`
  `mv ./html5-boilerplate/.htaccess ./.htaccess`
  `rm ./.htaccess`
  `rm -rf ./img`
  `rm ./readme.md`
  `rm ./robots.txt`
  `rm ./humans.txt`
  `rm ./404.html`
  `mv apple-touch-icon* ./images`
  `mv favicon.ico ./images`
  `touch css/application.css`
  `rm -rf html5-boilerplate`
  Rake::Task['gitinit'].invoke
end

desc "Set up a new Email Template Project"
task :newemail do
  `git clone https://github.com/seanpowell/Email-Boilerplate.git .`
  `rm ./README.markdown`
  `rm ./contributors.txt`
  `rm ./email.html`
  `mv ./email_lite.html ./email.html`
  Rake::Task['gitinit'].invoke
end


desc "Compile non inline styles to inline styles for eDMs"
task :toinline do

  require 'net/http'
  require 'cgi'

  if File.exist?("email.html")
    email = File.open("email.html", "rb")
    email_content = email.read

    #uses the http://inlinestyler.torchboxapps.com web service
    uri = URI('http://inlinestyler.torchboxapps.com/styler/convert/')
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data('source' => email_content, 'returnraw' => true)

    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end

    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      html = CGI.unescapeHTML(res.body)
      if File.exist?("email_compiled.html")
        system %Q{rm "email_compiled.html"}
      end
      
      file = File.new("email_compiled.html", "w")
      file.write(html)
      file.close

    else
      res.value
      puts "ERROR: inline service returned #{res.value}"
    end
  else
    puts "ERROR: missing an email template named 'email.html'"
  end

end

desc "Set up a blank project"
task :newblank => [:init] do
  `touch index.html`
  Rake::Task['gitinit'].invoke
end

desc "Create git repository"
task :gitinit do
  `git init . && git add . && git commit -m "Initial Commit."`
end

desc "Initialize project structure"
task :init do
  `mkdir coffee css images js`
  `touch coffee/application.coffee`
  `touch css/application.css`
end
