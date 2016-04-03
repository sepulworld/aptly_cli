require "bundler/gem_tasks"

require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.libs << "test"
  t.test_files = FileList['test/test_*.rb']
  t.verbose = true
end

task default: :test

task :docker_build do
  sh %{docker build -t sepulworld/aptly_api .}
end

task :docker_list_aptly do
  sh %{docker ps --filter ancestor='sepulworld/aptly_api' --format="{{.ID}}"}
end

task :docker_stop do
  sh %{docker stop $(docker ps --filter ancestor='sepulworld/aptly_api' --format="{{.ID}}")}
end

task :docker_run do
  sh %{docker run -d -p 8080:8080 sepulworld/aptly_api /bin/sh -c "aptly api serve"}
end
