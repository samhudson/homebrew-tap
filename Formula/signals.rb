class Signals < Formula
  desc "Menu bar lights for your AI agent sessions, and what they use"
  homepage "https://github.com/samhudson/signals"
  url "https://github.com/samhudson/signals/releases/download/v1.1.0/signals-1.1.0.tar.gz"
  sha256 "ab82afaba61c1d3f03eb37937317af6481caa7e44e405370c4355e158cbc0a2b"
  license "MIT"

  depends_on "jq"
  depends_on :macos

  def install
    # Build Signals.app (the menu bar app) with the Swift compiler from the
    # Command Line Tools, which Homebrew already requires.
    system "./script/build-app", buildpath/"libexec"
    libexec.install Dir["libexec/*"]
    bin.install "bin/signals"
  end

  def caveats
    <<~EOS
      Set up your agents (Claude Code, Codex, Gemini CLI, Cursor, Copilot):
        signals install

      Signals lives in your menu bar and starts at login.
    EOS
  end

  test do
    assert_path_exists libexec/"Signals.app/Contents/MacOS/Signals"
    assert_match version.to_s, shell_output("#{bin}/signals --version")
    assert_path_exists libexec/"signals-hook"
    assert_path_exists libexec/"signals-meter"
  end
end
