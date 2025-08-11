### Sonar Cloud Sync Plan (SwiftData + CloudKit)

## Goals
- Keep users’ journals in sync across their devices using their private iCloud.
- Be reliable, private, and reversible. No third‑party services. Minimal user friction.

## Non‑Goals (v1)
- Do not sync large audio blobs (`AudioAsset`) in v1. Entries sync without audio. Audio transfer is handled by export/import.
- No background tasks or push updates beyond what CloudKit/SwiftData provide automatically.

## Scope
- Sync models: `JournalEntry`, `Tag`, `MemoryThread`, `PromptStyle`, `UserSettings` (subset).
- Exclude: `AudioAsset.fileURL` (local only), any transient or cache data.

## STOP Gate
- Requires enabling iCloud/CloudKit capability and setting the CloudKit container identifier on the app target. Obtain approval before proceeding.

## Architecture
- Two `ModelConfiguration`s with a shared `Schema`:
  - Local configuration (default; stored on device).
  - Cloud configuration (CloudKit) with `cloudKitContainerIdentifier`.
- A `ModelContainerManager` builds and switches containers at runtime based on `UserSettings.iCloudSyncEnabled`.
- Use dependency injection via SwiftUI’s `.modelContainer(...)` so Views and services work unchanged.

## Data Flow
- When iCloud sync is ON, SwiftData + CloudKit replicate changes automatically.
- On first enable, migrate local records to the cloud container, preserving UUIDs and relationships.
- When turning OFF, switch back to the local container. The user’s cloud copy is left intact unless they choose to purge (advanced/optional).

## Conflict Resolution
- Scalars: last‑write‑wins using `updatedAt` on each model.
- Relationships: prefer union (e.g., tags list, thread memberships).
- Deletions: tombstones with `updatedAt`; latest change wins.

## UX
- Settings → “iCloud sync” toggle with short explanation: “Private sync of your journal metadata through iCloud.”
- Preflight checks when enabling: iCloud account available, iCloud Drive enabled; helpful errors if not.
- Migration sheet with progress (records migrated, ETA). Cancellable.
- Status line in Settings: “Last synced: <time>”.
- On disable: confirmation dialog → switch locally. Optional advanced button: “Remove cloud copy” (deferred/optional).

## Implementation Steps
1) Capability (STOP gate): Enable iCloud/CloudKit for the app. Set `cloudKitContainerIdentifier`.
2) Container wiring:
   - Define `Schema([JournalEntry, Tag, MemoryThread, PromptStyle, UserSettings])`.
   - Create `ModelConfiguration.local` and `.cloud(ckIdentifier: ...)`.
   - Implement `ModelContainerManager` to build containers and expose an async `switch(to:)` method.
3) Boot logic:
   - At app launch, read `UserSettings.iCloudSyncEnabled` and choose the container accordingly.
4) Migration (enable path):
   - Read from current container (local). Batch fetch, then re‑insert into cloud container preserving UUIDs/relationships. Save in chunks (e.g., 200 rows per save).
   - Maintain `updatedAt` monotonicity.
   - Track progress (AsyncStream) → progress view.
5) Disable path:
   - Switch `.modelContainer` back to local; leave cloud data as is. Inform user.
6) Observability:
   - OSLog events: `sync_enabled`, `sync_disabled`, `sync_migrate_started/completed/failed`, `cloud_push/pull` durations.
7) Edge‑case handling:
   - Airplane mode / offline: continue local edits; CloudKit will sync later.
   - iCloud sign‑out: surface a notice; remain on local container.
   - Low storage: pause migration; surface actionable message.

## Security & Privacy
- No third‑party services. iCloud Private Database only.
- Do not include audio in v1 sync; entries remain private to device unless exported by the user.
- Avoid logging user content; OSLog uses privacy annotations.

## Testing & QA
- Device A/B conflict tests (edit same entry on two devices; verify last‑write‑wins and relationship unions).
- Toggle enable/disable repeatedly; ensure container switching is stable and data consistent.
- Airplane mode → edits → go online → verify sync.
- iCloud sign‑out/in behavior.
- Large library migration timing; cancellation and resume (resume by re‑running; idempotent inserts by UUID).

## Risks & Mitigations
- CloudKit latency: show “Last synced” and avoid blocking UI; rely on automatic replication.
- Schema migrations: version SwiftData models carefully; test CloudKit schema upgrades before release.
- User confusion about audio: show a small note on entry detail if audio missing on this device (“Transfer audio via Export”).

## Timeline
- Phase 0 (approval): Capability enablement.
- Phase 1: Container wiring, toggle UI, migration with progress, status line.
- Phase 2: Conflict/union polish, error surfaces, additional analytics.
- Phase 3 (optional): Cloud purge command and more detailed status UI.

## Acceptance Criteria
- Toggle ON starts migration and switches to Cloud container; post‑migration edits sync across devices.
- Toggle OFF returns to local container without data loss.
- Conflicts resolve per policy; relationships behave as unions.
- No crashes; offline operation intact; privacy preserved.

