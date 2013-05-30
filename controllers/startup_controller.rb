class StartupController < Rubot::Controller
  command :startup do
    reply Startup.random
  end
end

