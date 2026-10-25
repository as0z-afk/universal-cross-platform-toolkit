# Security Policy

## Supported reports
Report suspected vulnerabilities privately to the repository maintainer before opening a public issue. Do not attach access tokens, private histories, personal channel exports, or production secrets.

## Security boundaries
- No system/browser preferences are modified by default.
- Network updates are opt-in and hash-pinned.
- Downloaded payloads are treated as data and are never executed.
- Updater writes are confined to `managed/`; unknown files are not overwritten or removed.
- Authentication-cookie injection, paywall bypass, disabling browser security, remote debugging exposure, and `--no-sandbox` workflows are not supported.

## Release checks
Run `python -m unittest discover -s tests -v`, inspect `MANIFEST.json`, verify release hashes independently, and use a disposable test root before applying update manifests. If rollback preconditions fail, do not manually force it; inspect file differences and restore from backups after review.
