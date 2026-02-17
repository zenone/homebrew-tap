# typed: false
# frozen_string_literal: true

class Upkeep < Formula
  include Language::Python::Virtualenv

  desc "Modern, safe-by-default maintenance toolkit for macOS"
  homepage "https://github.com/zenone/upkeep"
  url "https://github.com/zenone/upkeep/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "1d6dcf431bded72d5758c0210718a8200e0397b649d1214d64135c2266161c7f"
  license "MIT"
  head "https://github.com/zenone/upkeep.git", branch: "main"

  depends_on "python@3.12"
  depends_on "node" => :build  # For building TypeScript frontend
  depends_on :macos

  def install
    # Create virtual environment
    venv = virtualenv_create(libexec, "python3.12")
    
    # Install Python package and dependencies
    venv.pip_install_and_link buildpath
    
    # Build the web frontend (TypeScript -> JS)
    system "npm", "install", "--ignore-scripts"
    system "npm", "run", "build:web"
    
    # Install the main bash script
    libexec.install "upkeep.sh"
    
    # Install the web runner script
    libexec.install "run-web.sh"
    
    # Install the daemon installer
    libexec.install "install-daemon.sh"
    
    # Create wrapper script that sets up environment
    (bin/"upkeep").write <<~EOS
      #!/bin/bash
      export UPKEEP_HOME="#{libexec}"
      export PATH="#{libexec}/bin:$PATH"
      exec "#{libexec}/bin/upkeep" "$@"
    EOS
    
    # Create upkeep-web command for launching web UI
    (bin/"upkeep-web").write <<~EOS
      #!/bin/bash
      export UPKEEP_HOME="#{libexec}"
      export PATH="#{libexec}/bin:$PATH"
      cd "#{libexec}"
      exec bash "#{libexec}/run-web.sh" "$@"
    EOS
    
    # Create upkeep-sh command for the bash maintenance script
    (bin/"upkeep-sh").write <<~EOS
      #!/bin/bash
      exec bash "#{libexec}/upkeep.sh" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Upkeep has been installed! Available commands:

        upkeep          - Python CLI for system info and analysis
        upkeep-web      - Launch the web dashboard (http://localhost:8080)
        upkeep-sh       - Direct bash script for maintenance operations

      Quick start:
        upkeep-web              # Opens web UI in browser
        upkeep-sh --status      # Quick system health check
        upkeep-sh --all-safe    # Run safe maintenance operations

      To install the background daemon (for scheduled maintenance):
        sudo #{libexec}/install-daemon.sh

      For more information:
        https://github.com/zenone/upkeep
    EOS
  end

  test do
    assert_match "upkeep", shell_output("#{bin}/upkeep --help")
    assert_match version.to_s, shell_output("#{bin}/upkeep --version")
  end
end
