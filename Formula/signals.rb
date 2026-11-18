class Signals < Formula
  desc "Menu bar lights for your AI agent sessions, and what they use"
  homepage "https://github.com/samhudson/signals"
  url "https://github.com/samhudson/signals/releases/download/v1.3.0/signals-1.3.0.tar.gz"
  sha256 "ebf606c652e9843dbf13b87ab6e93df2e3de1c4760e60a70de34afef90ee6bea"
  license "MIT"

  bottle do
    root_url "https://github.com/samhudson/signals/releases/download/v1.3.0"
    sha256 cellar: :any_skip_relocation, all: "eaa2bc90ed2582e0936494127c1900d473c265947ad60be214f23c37346fadf7"
  end

  depends_on "go" => :build
  depends_on "jq"
  depends_on :macos

  def install
    # A bottle is built for Apple silicon and Intel at once.
    ENV["SIGNALS_UNIVERSAL"] = "1" if build.bottle?
    # The menu bar app (Swift) and the engine that counts each agent's API calls (Go).
    system "./script/build-app", buildpath/"libexec"
    system "./script/build-core", buildpath/"libexec/engine"
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
    assert_match "\"tools\"", shell_output("#{libexec}/engine/signals-core usage summary --json --no-scan")
  end
end
