build-tests:
	@cd Scripts/Sources/TestScript && \
	swiftyscripty -b && \
	cp ./TestScript ../../bin/test-script

build-tests-ci:
	@cd Scripts/Sources/TestScript && \
	swift build --configuration release && \
	cp .build/release/TestScript ../../bin/test-script

.PHONY: tests
