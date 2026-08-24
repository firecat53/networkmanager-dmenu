SCRIPT := networkmanager_dmenu

.PHONY: version check clean release

version:
	@grep -Po '^__version__ = "\K[^"]+' $(SCRIPT)

# The flake derives its version from __version__ in the script, so the script
# and the tags drifting apart makes a build claim a version that was never
# released. Unlike the checks inside `release`, this is an invariant that can
# be tested at any time.
check:
	@v=$$(grep -Po '^__version__ = "\K[^"]+' $(SCRIPT)); \
	t=$$(git describe --tags --abbrev=0 2>/dev/null); \
	echo "script:     $$v"; \
	echo "latest tag: $${t:-(none)}"; \
	test "v$$v" = "$$t" || { \
		echo "MISMATCH: a build from here would claim v$$v"; exit 1; }

clean:
	rm -rf __pycache__

# Bump __version__, commit, and create an annotated (and, per tag.gpgsign,
# signed) tag. $EDITOR is prefilled with the version and one bullet per commit
# since the last tag.
# Usage: make release VERSION=2.7.0
release:
	@test -n "$(VERSION)" || { echo "Usage: make release VERSION=x.y.z"; exit 1; }
	@echo "$(VERSION)" | grep -Pq '^\d+\.\d+\.\d+$$' || \
		{ echo "VERSION must be x.y.z"; exit 1; }
	@test -z "$$(git status --porcelain -uno)" || \
		{ echo "Tracked files have uncommitted changes; commit or stash first"; exit 1; }
	@git rev-parse -q --verify refs/tags/v$(VERSION) >/dev/null && \
		{ echo "Tag v$(VERSION) already exists"; exit 1; } || true
	@if [ "$$($(MAKE) -s version)" = "$(VERSION)" ]; then \
		echo "__version__ is already $(VERSION), tagging the current commit"; \
	else \
		sed -i 's/^__version__ = ".*"$$/__version__ = "$(VERSION)"/' $(SCRIPT) && \
		git commit -m "Bump version to $(VERSION)" $(SCRIPT); \
	fi
	@test "$$($(MAKE) -s version)" = "$(VERSION)" || \
		{ echo "Failed to set version"; exit 1; }
	# Open the tag message prefilled with the version as the subject and one
	# bullet per commit since the last tag.
	@notes=$$(mktemp); \
	prev=$$(git describe --tags --abbrev=0 2>/dev/null); \
	{ echo "v$(VERSION)"; echo; \
	  git log --no-merges --invert-grep \
		--grep='^Bump version to ' --format='* %s' \
		$${prev:+$$prev..}HEAD; } > $$notes; \
	git tag -a -e -F $$notes v$(VERSION); status=$$?; \
	rm -f $$notes; \
	test $$status -eq 0 || exit $$status; \
	test -n "$$(git for-each-ref --format='%(contents:body)' \
		refs/tags/v$(VERSION))" || { \
		git tag -d v$(VERSION) >/dev/null; \
		echo "Tag message body is empty, so the release notes would be too."; \
		echo "Tag not created."; \
		if [ "$$(git log -1 --format=%s)" = "Bump version to $(VERSION)" ]; then \
			echo "The version bump commit is still there;"; \
			echo "undo it with: git reset --hard HEAD^"; \
		fi; \
		exit 1; }
	@$(MAKE) -s check
	@echo
	@echo "Tagged v$(VERSION). Push with:"
	@echo "    git push origin $$(git rev-parse --abbrev-ref HEAD) --follow-tags"
