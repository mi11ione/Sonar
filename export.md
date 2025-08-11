### Sonar Export/Import Plan (Production-Ready)

## Goals
- Allow users to back up, move, or archive their journals privately without servers.
- Preserve structure: entries, tags, threads, summaries, and audio attachments.
- Provide optional package encryption with a passphrase.

## Non‑Goals (v1)
- Do not upload to cloud providers automatically; user invokes system share/export.
- No partial merge conflict UI; deterministic merge rules only.

## Package Format
- Extension: `.sonarpkg`
- Structure: single binary container composed of Header + Manifest (JSON) + Data section.
- Header (fixed size):
  - Magic: `SONARPKG\0`
  - Version: `1`
  - Flags: bitmask (e.g., ENCRYPTED, COMPRESSED)
  - Salt (if encrypted): 16 bytes
  - Nonce (if encrypted): 12 bytes (AES.GCM) or 24 bytes (ChaChaPoly)
  - Reserved: for future use
- Manifest (JSON, UTF‑8):
  - exportInfo: { createdAt, appVersion, device }
  - selection: scope description (all | dateRange | tags | threads | ids)
  - entries: array of objects with fields:
    - id (UUID), createdAt, updatedAt, title, transcript, summary, moodScore, moodLabel, tagNames: [String], threadTitles: [String]
    - audio: { offset, length, sha256, fileName } | null
  - tags: [{ name }]
  - threads: [{ title, entryIds: [UUID] }]
  - checksums: { manifestSha256 }
- Data section (binary):
  - Concatenated audio payloads in the order referenced by entries[].audio with offsets/lengths from manifest.

## Compression & Encryption
- Compression: LZFSE (via `Compression` framework) applied to the whole payload prior to encryption.
- Encryption (optional): AES.GCM or ChaChaPoly (CryptoKit) over the compressed payload.
  - Key derivation: PBKDF2-HMAC-SHA256 with 100k iterations (CommonCrypto) using header.salt + user passphrase.
  - Store only salt and nonce in header; never store the key or passphrase.

## UX
- Settings → Data → Export
  - Scope picker: All entries, Date range, Tags, Threads, Manually select.
  - Toggle “Encrypt with passphrase”; secure field + confirm.
  - Progress sheet: counts, bytes written; cancellable.
  - Result: Share sheet for `.sonarpkg`.
- Settings → Data → Import
  - Document picker for `.sonarpkg`.
  - If encrypted: passphrase prompt.
  - Dry‑run summary: entries to add, update, skip; audio size; required space.
  - Confirm → progress sheet; final report with counts and any warnings.

## Implementation
- ExportActor
  - Query selections from SwiftData.
  - Build deduplicated tag list and thread mapping.
  - Stream audio files to a temporary file; compute SHA256 incrementally.
  - Construct manifest with accurate offsets/lengths and checksums.
  - Write header + manifest + data to temp; then compress/encrypt if selected.
  - Yield progress via AsyncStream; support cancellation.
- ImportActor
  - Read header, decrypt/decompress if needed.
  - Parse manifest and validate manifestSha256; validate each audio SHA256.
  - Preflight free space; estimate target size.
  - Merge strategy:
    - Upsert `Tag` by name; `MemoryThread` by title.
    - Upsert `JournalEntry` by UUID; if existing, update scalar fields when incoming.updatedAt is newer.
    - Attach audio by writing to `Application Support/Audio/<uuid>.caf` with `.completeUntilFirstUserAuthentication` and exclude from backup.
  - Save in batches; Spotlight reindex changed entries.
  - Cleanup temp files on success/failure/cancel.

## Error Handling
- Typed errors: wrongPassphrase, integrityFailed, notEnoughSpace, cancelled, ioError.
- User‑friendly messages and retry paths.

## Observability
- OSLog events: `export_started/completed/failed`, `import_started/completed/failed`; record counts, durations (no user content).

## Security
- No passphrase logging; zero passphrase persistence; ephemeral key derivation only.
- Warn users that lost passphrases cannot be recovered.

## Testing
- Unit: KDF + AEAD round‑trip; manifest SHA validation; offset/length correctness; large audio stream chunking.
- UI: export/import flows, wrong passphrase, low disk, cancel/resume.

## Phased Rollout
- Phase 1: Unencrypted package, manifest + audio, integrity checks, import merge.
- Phase 2: Add compression + encryption; import dry‑run; cancellation polish; better progress UI.
- Phase 3: Advanced scopes and partial repair tools.

## Acceptance Criteria
- Export produces a valid `.sonarpkg` that re‑imports identically (content‑equivalent) on a clean device.
- Import merges deterministically, with no duplicates; audio placed and playable; indexes updated.
- Cancel leaves no leftover temp files; encryption works and fails clearly with wrong passphrase.

