class SamHillsController < Rubot::Controller
  command :sam_hills, :samhills do
    reply SamHillsAcronym.choose(message.text)
  end
end
