# typed: false
# frozen_string_literal: true

class Upkeep < Formula
  desc "Modern, safe-by-default maintenance toolkit for macOS"
  homepage "https://github.com/zenone/upkeep"
  url "https://github.com/zenone/upkeep/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "65cd4a1ec131fa636b9d47eb65bffd4806a7a9187ab71f0afcb1ca39ba3e9c26"
  license "MIT"
  head "https://github.com/zenone/upkeep.git", branch: "main"

  depends_on :macos
  depends_on "python@3.12"

  def install
    # Use Homebrew's python to create venv
    python = Formula["python@3.12"].opt_bin/"python3.12"

    # Create virtual environment with pip included
    system python, "-m", "venv", "--upgrade-deps", libexec

    # Install the main bash script
    libexec.install "upkeep.sh"

    # Install the daemon installer
    libexec.install "install-daemon.sh"

    # Store source for post_install
    (libexec/"src").install Dir["*"]

    # Create upkeep-sh command (bash script - no Python deps, can be linked now)
    (bin/"upkeep-sh").write <<~EOS
      #!/bin/bash
      exec bash "#{libexec}/upkeep.sh" "$@"
    EOS

    # Create wrapper scripts that will work after post_install runs
    # These go in bin/ now so Homebrew links them during install
    (bin/"upkeep").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/bin/upkeep" "$@"
    EOS

    (bin/"upkeep-web").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/bin/python" -m uvicorn upkeep.web.server:app --host 127.0.0.1 --port 8080 "$@"
    EOS
  end

  def post_install
    # Install Python package AFTER relocation phase to avoid pydantic_core warning
    system libexec/"bin/pip", "install", "--no-cache-dir", libexec/"src"
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
