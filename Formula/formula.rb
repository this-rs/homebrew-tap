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
  version "0.0.3"

  on_macos do
    on_arm do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-macos-arm64.tar.gz"
      sha256 "d05b441627cdf25d1295e6023d8a80a775c25e275d06cd3336826cf61f9b732c"
    end

    on_intel do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-macos-x86_64.tar.gz"
      sha256 "30406f700c9a7d5817e333a51ba3ea0807bb64228bd5fdb9280484dd2ca75637"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-linux-arm64.tar.gz"
      sha256 "fbad5cebc6c960e2a3d87a13b53c648163fbae8fc0e00fdff9e6419b63de1140"
    end

    on_intel do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-linux-x86_64.tar.gz"
      sha256 "d1d68732a3ed307a98c77fd048e5407f11dd178eed6aab0d201428cbb213a8b8"
    end
  end

  def install
    bin.install "orchestrator"
    bin.install "orch"
    bin.install "mcp_server"
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
