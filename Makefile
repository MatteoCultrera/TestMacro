build-tests:
	@cd Scripts/Sources/TestScript && \
	swiftyscripty -b && \
	cp ./TestScript ../../bin/test-script

.PHONY: tests
