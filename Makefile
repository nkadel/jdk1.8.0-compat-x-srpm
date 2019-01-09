#
# Build mock and local RPM versions of tools for Samba
#

# Assure that sorting is case sensitive
LANG=C

MOCKS+=samba4repo-f29-x86_64
MOCKS+=samba4repo-7-x86_64

#REPOBASEDIR=/var/www/linux/samba4repo
REPOBASEDIR:=`/bin/pwd`/../samba4repo

SPEC := `ls *.spec`

all:: verifyspec $(MOCKS)

# Oddness to get deduced .spec file verified
verifyspec:: FORCE
	@if [ ! -e $(SPEC) ]; then \
	    echo Error: SPEC file $(SPEC) not found, exiting; \
	    exit 1; \
	fi

srpm:: verifyspec FORCE
	@echo "Building SRPM with $(SPEC)"
	rm -rf rpmbuild
	rpmbuild --define '_topdir $(PWD)/rpmbuild' \
		--define '_sourcedir $(PWD)' \
		-bs $(SPEC) --nodeps

build:: srpm FORCE
	rpmbuild --define '_topdir $(PWD)/rpmbuild' \
		--rebuild rpmbuild/SRPMS/*.src.rpm

$(MOCKS):: verifyspec FORCE
	@if [ -e $@ -a -n "`find $@ -name \*.rpm`" ]; then \
		echo "	Skipping RPM populated $@"; \
	else \
		echo "	Building $@ RPMS with $(SPEC)"; \
		rm -rf $@; \
		mock -q -r $(PWD)/../$@.cfg \
		    --resultdir=$(PWD)/$@ \
		    --sources=$(PWD) --buildsrpm --spec=$(SPEC); \
		echo "Storing $@/*.src.rpm in $@.rpm"; \
		/bin/mv $@/*.src.rpm $@.src.rpm; \
		echo "Actally building RPMS in $@"; \
		rm -rf $@; \
		mock -q -r $(PWD)/../$@.cfg \
		     --resultdir=$(PWD)/$@ \
		     $@.src.rpm; \
	fi

mock:: $(MOCKS)

install:: $(MOCKS)
	@for repo in $(MOCKS); do \
	    echo Installing $$repo; \
	    case $$repo in \
		*-7-x86_64) yumrelease=el/7; yumarch=x86_64; ;; \
		*-29-x86_64) yumrelease=fedora/29; yumarch=x86_64; ;; \
		*-f29-x86_64) yumrelease=fedora/29; yumarch=x86_64; ;; \
		*) echo "Unrecognized relese for $$repo, exiting" >&2; exit 1; ;; \
	    esac; \
	    rpmdir=$(REPOBASEDIR)/$$yumrelease/$$yumarch; \
	    srpmdir=$(REPOBASEDIR)/$$yumrelease/SRPMS; \
	    echo "Pushing SRPMS to $$srpmdir"; \
	    rsync -av $$repo/*.src.rpm --no-owner --no-group $$repo/*.src.rpm $$srpmdir/. || exit 1; \
	    createrepo -q --update $$srpmdir/.; \
	    echo "Pushing RPMS to $$rpmdir"; \
	    rsync -av $$repo/*.rpm --exclude=*.src.rpm --exclude=*debuginfo*.rpm --no-owner --no-group $$repo/*.rpm $$rpmdir/. || exit 1; \
	    createrepo -q --update $$rpmdir/.; \
	    echo "Touching $(PWD)/../$$repo.cfg to clear cache"; \
	    /bin/touch --no-dereference $(PWD)/../$$repo.cfg; \
	done

clean::
	rm -rf */
	rm -rf rpmbuild
	rm -f *.out

realclean distclean:: clean
	rm -f *.rpm

FORCE:
