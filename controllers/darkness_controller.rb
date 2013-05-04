class DarknessController < Rubot::Controller
  listener do
    Darkness.spy(message)
  end

  command :darkness do
    reply "Darkness: #{Darkness.humanized_score}"
  end

  # for debugging purposes can remove later
  command :darkness_buffer_len do
    reply "Length: #{Darkness.log.length}"
  end

  on :reload do
    Darkness.clear
  end
end
