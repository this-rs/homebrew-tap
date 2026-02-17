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
  version "0.0.1"

  on_macos do
    on_arm do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-macos-arm64.tar.gz"
      sha256 "886c941ca144c54ddb07569fc78d6a90e8591322f3b0dc570a05c4520006e5a1"
    end

    on_intel do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-macos-x86_64.tar.gz"
      sha256 "dc52b70c3f77d28e2cb303118de560a3247fb5dd7395a29be3d5c9f857f95f44"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-linux-arm64.tar.gz"
      sha256 "229c679a88e3649f3b7f20539ef29c64c9e21715a9af9373c98ff0faf4164030"
    end

    on_intel do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-linux-x86_64.tar.gz"
      sha256 "c98d3d2a30137369e203b27df7227262c5e6d2765a0586ec52244e44b847f05d"
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
