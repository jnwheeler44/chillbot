class HelpController < Rubot::Controller
  command :help, :commands do
    reply "commands: !khash <coin> <khash>, !khashdiff <diff> <reward> <khash>, !price <coin> <amount>, !pool <coin>, !profits <khash (optional)>, !calc <math>, !multiport ... remember, you can always query/PM me so that I don't spam the channel."
  end
end
