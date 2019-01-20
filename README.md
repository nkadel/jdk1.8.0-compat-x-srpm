jdk1.8.0-compat-x-srpm
=====================

SRPM building tools to compile a compatibility plugin for Oracle JDK on RHEL.

The tool blocks openjdk from instlallation, includes a jdk1.8.0 dependency
to help enforce Oracle JDK RPM installation, and satisfies the "jre-headless"
requirement of other tools to prevent Oracle JDK from introducing broken
dependencies.

It's based on the obsolete
https://github.com/nkadel/jpackage-utils-compat-el5-srpm tool for RHEL
5 and jpackage packaging.

The "make" command will do these steps.

make build	# Build the package on the local OS
make all	# Use "mock" to build the packages with the designated
		# local mock configurations

	Nico Kadel-Garcia <nkadel@gmail.com>
