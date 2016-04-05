require "bundler/gem_tasks"

require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.libs << "test"
  t.test_files = FileList['test/test_*.rb']
  t.verbose = true
end

task default: :test

desc "Docker build image"
task :docker_build do
  sh %{docker build -t sepulworld/aptly_api .}
end

desc "List Docker Aptly running containers"
task :docker_list_aptly do
  sh %{docker ps --filter ancestor='sepulworld/aptly_api' --format="{{.ID}}"}
end

desc "Stop running Aptly Docker containers"
task :docker_stop do
  sh %{docker stop $(docker ps --filter ancestor='sepulworld/aptly_api' --format="{{.ID}}")}
end

desc "Start Aptly Docker container on port 8082"
task :docker_run do
  sh %{docker run -d -p 8082:8080 sepulworld/aptly_api /bin/sh -c "aptly api serve"}
end

desc "Show running Aptly process Docker stdout logs"
task :docker_show_logs do
  sh %{docker logs $(docker ps --filter ancestor='sepulworld/aptly_api' --format="{{.ID}}")}
end

desc "Restart Aptly docker container"
task :docker_restart => [:docker_stop, :docker_run] do
  puts "Restarting docker Aptly container"
end
