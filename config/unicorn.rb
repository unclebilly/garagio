@dir = "/opt/garagio/"

worker_processes 1
working_directory @dir

timeout 30
listen 8081
pid "#{@dir}tmp/pids/unicorn.pid"

stderr_path "#{@dir}log/unicorn.stderr.log"
stdout_path "#{@dir}log/unicorn.stdout.log"