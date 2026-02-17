# typed: false
# frozen_string_literal: true

class Upkeep < Formula
  desc "Modern, safe-by-default maintenance toolkit for macOS"
  homepage "https://github.com/zenone/upkeep"
  url "https://github.com/zenone/upkeep/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "1d6dcf431bded72d5758c0210718a8200e0397b649d1214d64135c2266161c7f"
  license "MIT"
  head "https://github.com/zenone/upkeep.git", branch: "main"

  depends_on :macos
  depends_on "python@3.12"

  def install
    # Use Homebrew's python to create venv
    python = Formula["python@3.12"].opt_bin/"python3.12"

    # Create virtual environment
    system python, "-m", "venv", libexec

    # Ensure pip is available
    system libexec/"bin/python", "-m", "ensurepip", "--upgrade"

    # Install the main bash script
    libexec.install "upkeep.sh"

    # Install the daemon installer
    libexec.install "install-daemon.sh"

    # Store source for post_install
    (libexec/"src").install Dir["*"]

    # Create placeholder for upkeep command (will be linked in post_install)
    # This ensures bin directory exists
    (bin/"upkeep-sh").write <<~EOS
      #!/bin/bash
      exec bash "#{libexec}/upkeep.sh" "$@"
    EOS
  end

  def post_install
    # Install Python package AFTER relocation phase to avoid pydantic_core warning
    system libexec/"bin/pip", "install", "--upgrade", "pip"
    system libexec/"bin/pip", "install", libexec/"src"

    # Create the main upkeep symlink
    bin.install_symlink libexec/"bin/upkeep"

    # Create upkeep-web command for launching web UI
    (bin/"upkeep-web").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/bin/python" -m uvicorn upkeep.web.server:app --host 127.0.0.1 --port 8080 "$@"
    EOS
    (bin/"upkeep-web").chmod 0755
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
  end
end
