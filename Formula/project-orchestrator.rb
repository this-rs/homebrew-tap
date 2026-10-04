# typed: false
# frozen_string_literal: true

# Homebrew formula for Project Orchestrator
#
# Install: brew install this-rs/tap/project-orchestrator
#
# This formula downloads pre-built binaries from GitHub Releases.
# SHA256 checksums are updated automatically by the release CI.
class ProjectOrchestrator < Formula
  desc "AI agent orchestrator with Neo4j knowledge graph, Meilisearch, and Tree-sitter"
  homepage "https://github.com/this-rs/project-orchestrator"
  license "MIT"
  version "0.0.16"

  on_macos do
    on_arm do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-macos-arm64.tar.gz"
      sha256 "249d890b1773961b929818b675fc0127d8ead8dfaa74e044b01b9a2386f1597c"
    end

    on_intel do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-macos-x86_64.tar.gz"
      sha256 "7ab3e1fe8af97a3043d2270f4f3806f5fe27e847578f2870d1d44ea848687cb4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-linux-arm64.tar.gz"
      sha256 "815323db6288c7a34526af22c8b3dc50239207af9cec9c729b881626fd841639"
    end

    on_intel do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-linux-x86_64.tar.gz"
      sha256 "8f7a0d15e5a35729c858e5ca11245b757162f5eb851149ee098a366aec5e8729"
    end
  end

  def install
    bin.install "orchestrator"
    bin.install "orch"
    bin.install "mcp_server"

    # ONNX Runtime dylib — present only in macOS x86_64 builds (dynamic linking
    # because ort-sys has no prebuilt static library for macOS Intel).
    # Binaries have @executable_path/../lib in their rpath for this layout.
    lib.install Dir["libonnxruntime*"] unless Dir["libonnxruntime*"].empty?
  end

  def caveats
    <<~EOS
      To start the server:
        brew services start project-orchestrator
        # or: orchestrator serve

      To configure Claude Code integration:
        orchestrator setup-claude
        (auto-configures the MCP server in Claude Code)

      The MCP server binary is at: #{opt_bin}/mcp_server
      The CLI tool is at: #{opt_bin}/orch

      Before starting, ensure Neo4j and MeiliSearch are running.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orchestrator --version")
  end

  service do
    run [opt_bin/"orchestrator", "serve"]
    keep_alive true
    working_dir var/"project-orchestrator"
    log_path var/"log/project-orchestrator.log"
    error_log_path var/"log/project-orchestrator-error.log"
  end
end
