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
  version "0.0.2"

  on_macos do
    on_arm do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-macos-arm64.tar.gz"
      sha256 "c1c23f35b6861879581d00b70b3db9a2863b80b44532bced17af493527c11170"
    end

    on_intel do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-macos-x86_64.tar.gz"
      sha256 "1bacbb863c4557c6c2e05fa562d960f10798ca2229832c51b3d91ac062c17892"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-linux-arm64.tar.gz"
      sha256 "d59cfa3314e5939a28735ea1c262dcfd1aa332bc62ca5738f74b15745975f858"
    end

    on_intel do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-linux-x86_64.tar.gz"
      sha256 "63250db1b0977e67bc0f8495a6caac2dabb5911d73f96d266a8d11ff3b66a3a9"
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
