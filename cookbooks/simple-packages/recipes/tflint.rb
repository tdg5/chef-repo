if platform?('mac_os_x')
  # tflint ships as a cask from the terraform-linters tap, not from
  # homebrew-core. Installing by its tap-qualified name taps it on demand.
  brew_cask 'terraform-linters/tap/tflint'
end
