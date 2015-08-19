TARGETS = debug-proxy request-rewrite-proxy simple-proxy testsuite

GHC = cabal exec -- ghc
GHCFLAGS = -Wall -fwarn-tabs

HSRC := $(shell find Network Test -name \*.hs)

all : $(TARGETS)

clean :
	find Network Test example -name \*.o -exec rm -f {} \;
	find Network Test example -name \*.hi -exec rm -f {} \;
	rm -rf $(TARGETS)

check : dist/build/testsuite/testsuite
	dist/build/testsuite/testsuite

hlint :
	hlint Network Test

init : cabal.sandbox.config

cabal.sandbox.config :
	cabal sandbox init
	cabal install --dependencies-only

#-------------------------------------------------------------------------------

dist/build/testsuite/testsuite : $(HSRC)
	mkdir -p dist/build/testsuite
	$(GHC) $(GHCFLAGS) -with-rtsopts="-M64m" -Wall -O2 -threaded Test/testsuite.hs -o $@

simple-proxy : example/simple-proxy.hs $(HSRC)
	$(GHC) $(GHCFLAGS) --make $< -o $@

debug-proxy : example/debug-proxy.hs $(HSRC)
	$(GHC) $(GHCFLAGS) --make $< -o $@

request-rewrite-proxy : example/request-rewrite-proxy.hs $(HSRC)
	$(GHC) $(GHCFLAGS) --make $< -o $@

print-%: ; @echo $*=$($*)
