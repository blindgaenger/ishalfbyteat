desc 'starts a development server'
task :server do
  system 'foreman start --port 3000'
end

desc 'deploys to heroku'
task :deploy do
  system 'git push heroku master && heroku config:push'
end
