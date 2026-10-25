# Universal Cross-Platform Toolkit

**Version:** 0.1.0 · **Status:** Preview / local sandbox validated · **Runtime:** Python 3.10+ standard library, plus a standalone offline web page.

A system-neutral, offline-first repository derived from the useful parts of the provided archive: OS/architecture detection, curated learning bookmarks, a dated browser-extension snapshot, an opt-in YouTube focus userscript, a static catalogue UI, and a reversible feature-aware updater. It is intentionally conservative: it does not tune system settings or browser flags automatically, does not execute downloaded code, and does not send telemetry.

## Start

- **View catalogue:** open [`web/index.html`](web/index.html) in a modern browser. It is self-contained and works offline; external sites open only after a deliberate click.
- **System report:** `python -m ubtoolkit info`
- **Dataset counts:** `python -m ubtoolkit catalogue`
- **Preview bookmark export:** `python -m ubtoolkit bookmarks --format html --output ./universal-bookmarks.html`
- **Feature preferences:** `python -m ubtoolkit features list`
- **Test:** `python -m unittest discover -s tests -v`

Python 3.10+ is required for the CLI. No Python dependencies are installed by this repository. On Windows use `run.ps1` or `run.bat`; on POSIX systems use `./run.sh`.

## Repository map

```text
adapters/           per-OS capability and limitation notes
assets/             original inline SVG mark
bookmarks/          generated Netscape HTML, JSON and CSV exports
browser/            opt-in, reversible userscripts
config/             safe defaults; no machine-specific settings
data/               sanitized resource data, curated extension snapshot, feature registry
integrations/       external-integration safety boundary
docs/               master spec/prompt, compatibility, provenance, tests and status
schemas/            update manifest and resource schema
scripts/            validation/build helpers
src/core/           logical core architecture map
tests/              offline unit tests
ubtoolkit/          standard-library CLI and safe updater
web/index.html      single-file offline catalogue
.github/workflows/  CI for available hosted OS runners
MANIFEST.json       SHA-256 inventory (excludes itself to avoid recursion)
```

## Safety contract

1. All system discovery is read-only. The only writes are explicit exports, local feature preferences, and updater-managed files.
2. Feature payloads are installed only under the toolkit's `managed/` root. The updater rejects path traversal, symlink targets, non-HTTPS schemes/redirects, literal private/local update hosts, untracked overwrites, changed tracked files, bad digests, oversized artifacts, duplicate paths, and malformed manifests.
3. `update --apply` requires `--manifest-sha256` for the exact manifest bytes. Obtain that digest from a trusted release channel independently. HTTPS + SHA-256 verifies transport/integrity only when the expected digest is trustworthy; it is not a digital publisher signature.
4. Payloads are staged, size-limited, hashed, atomically replaced where supported, and backed up. Rollback stops if updated files have changed since installation. Downloads are never executed.
5. The uninstaller removes only files listed in toolkit-owned state and creates a transaction backup. Unknown files and browser profiles are never deleted.
6. Network updates are opt-in. The resource web page itself makes no requests until a user clicks an external link.

See [`docs/MASTER_SPEC.md`](docs/MASTER_SPEC.md) for the ordered full specification, [`docs/IMPLEMENTATION_STATUS.md`](docs/IMPLEMENTATION_STATUS.md) for requirement traceability, [`docs/UPDATER.md`](docs/UPDATER.md), [`docs/THREAT_MODEL.md`](docs/THREAT_MODEL.md), [`docs/COMPATIBILITY.md`](docs/COMPATIBILITY.md) and [`docs/TEST_REPORT.md`](docs/TEST_REPORT.md) before applying any update.

## Updater example

Inspect the example manifest first:

```sh
python -m ubtoolkit update --manifest data/update-manifest.example.json --check
python -m ubtoolkit update --manifest data/update-manifest.example.json --dry-run
```

The example manifest has no payloads. For a real release, host data files over HTTPS, calculate each payload SHA-256, publish a manifest, and publish its raw-file SHA-256 through a trusted independent channel. Then run:

```sh
python -m ubtoolkit update --manifest release-manifest.json --manifest-sha256 TRUSTED_64_HEX_DIGEST --apply
python -m ubtoolkit update --manifest complete-repair.json --manifest-sha256 TRUSTED_64_HEX_DIGEST --repair
python -m ubtoolkit update --rollback
python -m ubtoolkit uninstall                 # preview only
python -m ubtoolkit uninstall --apply          # removes tracked files only
```

For a remote manifest, use `--manifest-url https://...` and supply the same trusted `--manifest-sha256`. Review diffs and the release manifest before applying. Never use a hash copied from the same untrusted location as the manifest.

## Feature handling

`features enable/disable FEATURE_ID` changes a local preference only; it does not modify browser settings or run installers. Real data-file feature installation/removal uses the signed-off manifest flow above, with per-file ownership tracking. Unknown or modified files are preserved.

## Browser focus filter

Install `browser/youtube-focus-filter.user.js` manually through a userscript manager. It starts with keyword filtering disabled, provides on-page Enable/Disable, Shorts, Edit terms, Restore, and Close controls, stores preferences with the userscript manager, and makes no network calls. It is a presentation filter, not a network blocker, safety classifier, or control over YouTube's recommendation algorithm. Review the script before installation and disable/remove it from the manager to uninstall.

## Data caveats

- The 244-resource dataset is sanitized from the supplied ZIP and checked syntactically; links were **not live-checked during this build**. Availability, sign-in rules, pricing, and page content can change.
- The 40-record extension catalogue is a historical **2026-10-24** snapshot copied from the supplied archive. Ratings, publisher signals, updates, permissions, and compatibility are not security endorsements; see `data/extensions-curated.json` for captured caveats.
- Browser/search histories, individual channel exports, system identifiers, machine-specific browser flags, authentication-cookie injection material, paywall-bypass script, bundled `.git` directories, and unrelated libraries/documents were intentionally excluded from the public repository.
- Third-party marks/names remain owned by their respective holders. Source asset rights were not independently verified; see [`docs/DATA_PROVENANCE.md`](docs/DATA_PROVENANCE.md).

## Platform scope

Targets Windows, Linux, BSD, macOS and ChromeOS where the runtime is available, with detection for x86/i686, x86_64, ARM32, AArch64, ppc64le/ppc64, RISC-V 64 and s390x where reported. Detection is not a claim that every combination has been runtime-tested. ChromeOS may report as Linux inside Crostini; adapter-specific operations are no-op/documentation-only unless explicitly supported. See compatibility matrix.

## One-million-character target

The archive contains extensive duplicated prompts, generated documents, browser histories, third-party dependencies and personal exports. This release consolidates useful behavior into modular, testable files instead of manufacturing filler to hit a character count. Expansion is organized by priority: safety and rollback, portability, integrity, tests, then optional features.
