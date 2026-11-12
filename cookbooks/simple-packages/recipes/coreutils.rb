# GNU coreutils for macOS, installed with a `g` prefix (gls, gdate, ...) so the
# BSD tools stay the defaults. Ubuntu already ships GNU coreutils.
if platform?('mac_os_x')
  package 'coreutils'
end
