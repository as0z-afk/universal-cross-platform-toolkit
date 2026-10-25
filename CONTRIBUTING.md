# Contributing

1. Keep runtime code in the Python standard library unless a dependency has a documented need and license.
2. Prefer read-only discovery, explicit opt-in, idempotence, bounded resource use, and safe no-op behavior.
3. Never introduce code that disables TLS validation, browser sandbox/site isolation/safe browsing, leaks debug ports, or executes a remote response.
4. Add unit tests for new path parsing, update operations, feature removal and rollback. Network tests must be opt-in and never required by CI.
5. Do not commit browser/search history, cookies, identifiers, local paths, exports, large generated dependencies, or secrets.
6. Update documentation, changelog, compatibility limitations and the manifest generator when changing files.
7. Mark platform support as untested unless CI or a documented manual test actually ran on it.
