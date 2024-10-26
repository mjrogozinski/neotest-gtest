.PHONY: test unit-test integration-test submodules

MINIMAL_INIT = lua/tests/unit/minimal_init.lua
PLENARY_OPTS = { minimal_init='${MINIMAL_INIT}', sequential=true, timeout=5000}
GTEST_TAG ?= main
export GTEST_TAG
export GTEST_PATH

test: unit-test integration-test ;

unit-test:
	nvim --headless -c "PlenaryBustedDirectory lua/tests/unit ${PLENARY_OPTS}"

integration-test-all:
	@for gtest_tag in release-1.10.0 release-1.11.0 release-1.12.1 v1.13.0 v1.14.0 main; do \
		echo "Running integration tests with gtest tag $$gtest_tag"; \
		($(MAKE) clean-tests && $(MAKE) integration-test GTEST_TAG=$$gtest_tag) || exit 1; \
	done

integration-test: build-tests
	nvim --headless -c "PlenaryBustedDirectory lua/tests/integration ${PLENARY_OPTS}"

build-tests: lua/tests/integration/cpp
	$(MAKE) -C lua/tests/integration/cpp build

clean-tests: lua/tests/integration/cpp
	$(MAKE) -C lua/tests/integration/cpp clean
