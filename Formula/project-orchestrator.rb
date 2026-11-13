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
  license all_of: ["MIT", "BUSL-1.1"]
  version "0.0.19"

  on_macos do
    on_arm do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-macos-arm64.tar.gz"
      sha256 "6f2298a105bf68240516af5dc4358f6b72abc43eb39514cb118dc7a8c61afed5"
    end

    on_intel do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-macos-x86_64.tar.gz"
      sha256 "389d06bbb4d6efdc47768f92a2043fd6545a58a8e26df3d1ca66fcded1b91e62"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-linux-arm64.tar.gz"
      sha256 "e37b5fd34b532ed91df94b10a3f201a6b1f8c681aa3e81a6c0110ab00db5ace3"
    end

    on_intel do
      url "https://github.com/this-rs/project-orchestrator/releases/download/v#{version}/orchestrator-full-#{version}-linux-x86_64.tar.gz"
      sha256 "0de7be2c8e4646b9bd3db3db1259db377df9a3b0ed9697fc60454056c9ee43b0"
    end
  end

  def install
    bin.install "orchestrator"
    bin.install "orch"
    bin.install "mcp_server"
    # The files, shell and web tools of a native session, next to the server (P6). Absent from
    # releases made before it shipped.
    bin.install "nexus-tools" if File.exist?("nexus-tools")

    # ONNX Runtime dylib — present only in macOS x86_64 builds (dynamic linking
    # because ort-sys has no prebuilt static library for macOS Intel).
    # Binaries have @executable_path/../lib in their rpath for this layout.
    lib.install Dir["libonnxruntime*"] unless Dir["libonnxruntime*"].empty?

    # Our license (LICENSE, LICENSE-MIT, LICENSE-EE) and the third-party notices of the binaries.
    # Absent from releases made before they shipped.
    license_files = Dir["LICENSE*", "THIRD-PARTY-LICENSES.txt"]
    prefix.install license_files unless license_files.empty?
  end

  def caveats
    <<~EOS
      To start the server:
        brew services start project-orchestrator
        # or: orchestrator serve

      Chat providers: Claude Code is optional. An OpenAI-compatible
      endpoint, Codex or an ACP agent is added in Settings > Providers.

      Optional, only if you use Claude Code:
        orchestrator setup-claude
        (registers the MCP server in Claude Code; does nothing without it)

      The MCP server binary is at: #{opt_bin}/mcp_server
      The CLI tool is at: #{opt_bin}/orch
      The native-session tools (nexus-tools) are at: #{opt_bin}/nexus-tools

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
